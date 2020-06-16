#!/bin/bash
printf "Start kiosk\n"

input="$HOME/kiosk.conf"
sites=""
while IFS= read -r var
do
  sites=$sites" "$var
done < "$input"

xset s noblank
xset s off
xset -dpms

unclutter -idle 0.5 -root &

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences

/usr/bin/chromium-browser --disable-component-update --check-for-update-interval=31536000 --enable-features=OverlayScrollbar --disable-restore-session-state --noerrdialogs --disable-infobars --kiosk $sites &

while true; do
   xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab;
   sleep 10
done
