fontpath="@SYSTEM_FONTS@"
[ -e "$HOME"/.fonts/fonts.dir ] && fontpath="$fontpath,$HOME/.fonts"
[ -e "$HOME"/Library/Fonts/fonts.dir ] && fontpath="$fontpath,$HOME/Library/Fonts"
[ -e /Library/Fonts/fonts.dir ] && fontpath="$fontpath,/Library/Fonts"
[ -e /System/Library/Fonts/fonts.dir ] && fontpath="$fontpath,/System/Library/Fonts"
@XSET@ fp= "$fontpath"
unset fontpath
