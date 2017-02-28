#!@shell@

PATH="$PATH${PATH:+:}@suffixPATH@"

export QT_PLUGIN_PATH="$QT_PLUGIN_PATH${QT_PLUGIN_PATH:+:}@QT_PLUGIN_PATH@"
export QML_IMPORT_PATH="$QML_IMPORT_PATH${QML_IMPORT_PATH:+:}@QML_IMPORT_PATH@"
export QML2_IMPORT_PATH="$QML2_IMPORT_PATH${QML2_IMPORT_PATH:+:}@QML2_IMPORT_PATH@"

kbuildsycoca5

# Set the default GTK 2 theme
if ! [ -e $HOME/.gtkrc-2.0 ] \
     && [ -e /run/current-system/sw/share/themes/Breeze/gtk-2.0/gtkrc ]; then
    cat >$HOME/.gtkrc-2.0 <<EOF
# Default GTK+ 2 config for NixOS KDE 5
include "/run/current-system/sw/share/themes/Breeze/gtk-2.0/gtkrc"
gtk-theme-name="Breeze"
gtk-icon-theme-name="breeze"
gtk-fallback-icon-theme="hicolor"
gtk-cursor-theme-name="breeze_cursors"
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-menu-images=1
gtk-button-images=1
EOF
fi

if ! [ -e $HOME/.config/gtk-3.0/settings.ini ] \
       && [ -e /run/current-system/sw/share/themes/Breeze/gtk-3.0 ]; then
    cat >$HOME/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-theme-name=Breeze
gtk-icon-theme-name=breeze
gtk-fallback-icon-theme=hicolor
gtk-cursor-theme-name=breeze_cursors
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-menu-images=1
gtk-button-images=1
EOF
fi

# The KDE icon cache is supposed to update itself
# automatically, but it uses the timestamp on the icon
# theme directory as a trigger.  Since in Nix the
# timestamp is always the same, this doesn't work.  So as
# a workaround, nuke the icon cache on login.  This isn't
# perfect, since it may require logging out after
# installing new applications to update the cache.
# See http://lists-archives.org/kde-devel/26175-what-when-will-icon-cache-refresh.html
rm -fv $HOME/.cache/icon-cache.kcache

# Qt writes a weird ‘libraryPath’ line to
# ~/.config/Trolltech.conf that causes the KDE plugin
# paths of previous KDE invocations to be searched.
# Obviously using mismatching KDE libraries is potentially
# disastrous, so here we nuke references to the Nix store
# in Trolltech.conf.  A better solution would be to stop
# Qt from doing this wackiness in the first place.
if [ -e $HOME/.config/Trolltech.conf ]; then
    sed -e '/nix\\store\|nix\/store/ d' -i $HOME/.config/Trolltech.conf
fi

if test "x$1" = x--failsafe; then
    KDE_FAILSAFE=1 # General failsafe flag
    KWIN_COMPOSE=N # Disable KWin's compositing
    QT_XCB_FORCE_SOFTWARE_OPENGL=1
    export KWIN_COMPOSE KDE_FAILSAFE QT_XCB_FORCE_SOFTWARE_OPENGL
fi

# When the X server dies we get a HUP signal from xinit. We must ignore it
# because we still need to do some cleanup.
trap 'echo GOT SIGHUP' HUP

# we have to unset this for Darwin since it will screw up KDE's dynamic-loading
unset DYLD_FORCE_FLAT_NAMESPACE

# Check if a KDE session already is running and whether it's possible to connect to X
kcheckrunning
kcheckrunning_result=$?
if test $kcheckrunning_result -eq 0 ; then
    echo "KDE seems to be already running on this display."
    xmessage -geometry 500x100 "KDE seems to be already running on this display."
	exit 1
elif test $kcheckrunning_result -eq 2 ; then
	echo "\$DISPLAY is not set or cannot connect to the X server."
    exit 1
fi

# Boot sequence:
#
# kdeinit is used to fork off processes which improves memory usage
# and startup time.
#
# * kdeinit starts klauncher first.
# * Then kded is started. kded is responsible for keeping the sycoca
#   database up to date. When an up to date database is present it goes
#   into the background and the startup continues.
# * Then kdeinit starts kcminit. kcminit performs initialisation of
#   certain devices according to the user's settings
#
# * Then ksmserver is started which takes control of the rest of the startup sequence

# We need to create config folder so we can write startupconfigkeys
configDir=$(qtpaths --writable-path GenericConfigLocation)
mkdir -p "$configDir"

if ! [ -e $configDir/kcminputrc ]; then
    cat >$configDir/kcminputrc <<EOF
[Mouse]
cursorTheme=breeze_cursors
cursorSize=0
EOF
fi

THEME=org.kde.breeze
#This is basically setting defaults so we can use them with kstartupconfig5
#We cannot set the equivilant of THEME here as it will generate an
#invalid variable name (with dots)
cat >$configDir/startupconfigkeys <<EOF
kcminputrc Mouse cursorTheme 'breeze_cursors'
kcminputrc Mouse cursorSize ''
ksplashrc KSplash Theme ${THEME}.desktop
ksplashrc KSplash Engine KSplashQML
kdeglobals KScreen ScreenScaleFactors ''
kcmfonts General forceFontDPI 0
EOF

# preload the user's locale on first start
plasmalocalerc=$configDir/plasma-localerc
test -f $plasmalocalerc || {
cat >$plasmalocalerc <<EOF
[Formats]
LANG=$LANG
EOF
}

# export LC_* variables set by kcmshell5 formats into environment
# so it can be picked up by QLocale and friends.
exportformatssettings=$configDir/plasma-locale-settings.sh
test -f $exportformatssettings && {
    . $exportformatssettings
}

# Write a default kdeglobals file to set up the font
kdeglobalsfile=$configDir/kdeglobals
test -f $kdeglobalsfile || {
cat >$kdeglobalsfile <<EOF
[General]
XftAntialias=true
XftHintStyle=hintmedium
XftSubPixel=none
EOF
}

kstartupconfig5
returncode=$?
if test $returncode -ne 0; then
    xmessage -geometry 500x100 "kstartupconfig5 does not exist or fails. The error code is $returncode. Check your installation."
    exit 1
fi
[ -r $configDir/startupconfig ] && . $configDir/startupconfig

if [ "$kdeglobals_kscreen_screenscalefactors" ]; then
    export QT_SCREEN_SCALE_FACTORS="$kdeglobals_kscreen_screenscalefactors"
fi
#Manually disable auto scaling because we are scaling above
#otherwise apps that manually opt in for high DPI get auto scaled by the developer AND manually scaled by us
export QT_AUTO_SCREEN_SCALE_FACTOR=0

XCURSOR_PATH=~/.icons
IFS=":" read -r -a xdgDirs <<< "$XDG_DATA_DIRS"
for xdgDir in "${xdgDirs[@]}"; do
    XCURSOR_PATH="$XCURSOR_PATH:$xdgDir/icons"
done
export XCURSOR_PATH

# XCursor mouse theme needs to be applied here to work even for kded or ksmserver
if test -n "$kcminputrc_mouse_cursortheme" -o -n "$kcminputrc_mouse_cursorsize" ; then

    kapplymousetheme "$kcminputrc_mouse_cursortheme" "$kcminputrc_mouse_cursorsize"
    if test $? -eq 10; then
        XCURSOR_THEME=breeze_cursors
        export XCURSOR_THEME
    elif test -n "$kcminputrc_mouse_cursortheme"; then
        XCURSOR_THEME="$kcminputrc_mouse_cursortheme"
        export XCURSOR_THEME
    fi
    if test -n "$kcminputrc_mouse_cursorsize"; then
        XCURSOR_SIZE="$kcminputrc_mouse_cursorsize"
        export XCURSOR_SIZE
    fi
fi

unset THEME

# Set a left cursor instead of the standard X11 "X" cursor, since I've heard
# from some users that they're confused and don't know what to do. This is
# especially necessary on slow machines, where starting KDE takes one or two
# minutes until anything appears on the screen.
#
# If the user has overwritten fonts, the cursor font may be different now
# so don't move this up.
#
xsetroot -cursor_name left_ptr

if test "$kcmfonts_general_forcefontdpi" -ne 0; then
    xrdb -quiet -merge -nocpp <<EOF
Xft.dpi: $kcmfonts_general_forcefontdpi
EOF
fi

dl=$DESKTOP_LOCKED
unset DESKTOP_LOCKED # Don't want it in the environment

ksplash_pid=
if test -z "$dl"; then
  # the splashscreen and progress indicator
  case "$ksplashrc_ksplash_engine" in
    KSplashQML)
      ksplash_pid=$(ksplashqml "${ksplashrc_ksplash_theme}" --pid)
      ;;
    None)
      ;;
    *)
      ;;
  esac
fi

echo 'startkde: Starting up...'  1>&2

# Make sure that D-Bus is running
if qdbus >/dev/null 2>/dev/null; then
    : # ok
else
    echo 'startkde: Could not start D-Bus. Can you call qdbus?'  1>&2
    test -n "$ksplash_pid" && kill "$ksplash_pid" 2>/dev/null
    xmessage -geometry 500x100 "Could not start D-Bus. Can you call qdbus?"
    exit 1
fi

# Mark that full KDE session is running (e.g. Konqueror preloading works only
# with full KDE running). The KDE_FULL_SESSION property can be detected by
# any X client connected to the same X session, even if not launched
# directly from the KDE session but e.g. using "ssh -X", kdesu. $KDE_FULL_SESSION
# however guarantees that the application is launched in the same environment
# like the KDE session and that e.g. KDE utilities/libraries are available.
# KDE_FULL_SESSION property is also only available since KDE 3.5.5.
# The matching tests are:
#   For $KDE_FULL_SESSION:
#     if test -n "$KDE_FULL_SESSION"; then ... whatever
#   For KDE_FULL_SESSION property:
#     xprop -root | grep "^KDE_FULL_SESSION" >/dev/null 2>/dev/null
#     if test $? -eq 0; then ... whatever
#
# Additionally there is (since KDE 3.5.7) $KDE_SESSION_UID with the uid
# of the user running the KDE session. It should be rarely needed (e.g.
# after sudo to prevent desktop-wide functionality in the new user's kded).
#
# Since KDE4 there is also KDE_SESSION_VERSION, containing the major version number.
# Note that this didn't exist in KDE3, which can be detected by its absense and
# the presence of KDE_FULL_SESSION.
#
KDE_FULL_SESSION=true
export KDE_FULL_SESSION
xprop -root -f KDE_FULL_SESSION 8t -set KDE_FULL_SESSION true

KDE_SESSION_VERSION=5
export KDE_SESSION_VERSION
xprop -root -f KDE_SESSION_VERSION 32c -set KDE_SESSION_VERSION 5

KDE_SESSION_UID=$(id -ru)
export KDE_SESSION_UID

XDG_CURRENT_DESKTOP=KDE
export XDG_CURRENT_DESKTOP

# Source scripts found in <config locations>/plasma-workspace/env/*.sh
# (where <config locations> correspond to the system and user's configuration
# directories, as identified by Qt's qtpaths,  e.g.  $HOME/.config
# and /etc/xdg/ on Linux)
#
# This is where you can define environment variables that will be available to
# all KDE programs, so this is where you can run agents using e.g. eval `ssh-agent`
# or eval `gpg-agent --daemon`.
# Note: if you do that, you should also put "ssh-agent -k" as a shutdown script
#
# (see end of this file).
# For anything else (that doesn't set env vars, or that needs a window manager),
# better use the Autostart folder.

IFS=":" read -r -a scriptpath <<< $(qtpaths --paths GenericConfigLocation)
# Add /env/ to the directory to locate the scripts to be sourced
for prefix in "${scriptpath[@]}"; do
  for file in "$prefix"/plasma-workspace/env/*.sh; do
    test -r "$file" && . "$file" || true
  done
done

# At this point all the environment is ready, let's send it to kwalletd if running
if test -n "$PAM_KWALLET_LOGIN" ; then
    env | socat STDIN UNIX-CONNECT:$PAM_KWALLET_LOGIN
fi
# ...and also to kwalletd5
if test -n "$PAM_KWALLET5_LOGIN" ; then
    env | socat STDIN UNIX-CONNECT:$PAM_KWALLET5_LOGIN
fi

# At this point all environment variables are set, let's send it to the DBus session server to update the activation environment
dbus-update-activation-environment --systemd --all
if test $? -ne 0; then
  # Startup error
  echo 'startkde: Could not sync environment to dbus.'  1>&2
  test -n "$ksplash_pid" && kill "$ksplash_pid" 2>/dev/null
  xmessage -geometry 500x100 "Could not sync environment to dbus."
  exit 1
fi

# We set LD_BIND_NOW to increase the efficiency of kdeinit.
# kdeinit unsets this variable before loading applications.
LD_BIND_NOW=true start_kdeinit_wrapper --kded +kcminit_startup
if test $? -ne 0; then
  # Startup error
  echo 'startkde: Could not start kdeinit5. Check your installation.'  1>&2
  test -n "$ksplash_pid" && kill "$ksplash_pid" 2>/dev/null
  xmessage -geometry 500x100 "Could not start kdeinit5. Check your installation."
  exit 1
fi

qdbus org.kde.KSplash /KSplash org.kde.KSplash.setStage kinit

# finally, give the session control to the session manager
# see kdebase/ksmserver for the description of the rest of the startup sequence
# if the KDEWM environment variable has been set, then it will be used as KDE's
# window manager instead of kwin.
# if KDEWM is not set, ksmserver will ensure kwin is started.
# kwrapper5 is used to reduce startup time and memory usage
# kwrapper5 does not return useful error codes such as the exit code of ksmserver.
# We only check for 255 which means that the ksmserver process could not be
# started, any problems thereafter, e.g. ksmserver failing to initialize,
# will remain undetected.
test -n "$KDEWM" && KDEWM="--windowmanager $KDEWM"
# If the session should be locked from the start (locked autologin),
# lock now and do the rest of the KDE startup underneath the locker.
KSMSERVEROPTIONS=""
test -n "$dl" && KSMSERVEROPTIONS=" --lockscreen"
kwrapper5 ksmserver $KDEWM $KSMSERVEROPTIONS
if test $? -eq 255; then
  # Startup error
  echo 'startkde: Could not start ksmserver. Check your installation.'  1>&2
  test -n "$ksplash_pid" && kill "$ksplash_pid" 2>/dev/null
  xmessage -geometry 500x100 "Could not start ksmserver. Check your installation."
fi

wait_drkonqi=$(kreadconfig5 --file startkderc --group WaitForDrKonqi --key Enabled --default true)

if test x"$wait_drkonqi"x = x"true"x ; then
    # wait for remaining drkonqi instances with timeout (in seconds)
    wait_drkonqi_timeout=$(kreadconfig5 --file startkderc --group WaitForDrKonqi --key Timeout --default 900)
    wait_drkonqi_counter=0
    while qdbus | grep "^[^w]*org.kde.drkonqi" > /dev/null ; do
        sleep 5
        wait_drkonqi_counter=$((wait_drkonqi_counter+5))
        if test "$wait_drkonqi_counter" -ge "$wait_drkonqi_timeout" ; then
            # ask remaining drkonqis to die in a graceful way
            qdbus | grep 'org.kde.drkonqi-' | while read address ; do
                qdbus "$address" "/MainApplication" "quit"
            done
            break
        fi
    done
fi

echo 'startkde: Shutting down...'  1>&2
# just in case
test -n "$ksplash_pid" && kill "$ksplash_pid" 2>/dev/null

# Clean up
kdeinit5_shutdown

unset KDE_FULL_SESSION
xprop -root -remove KDE_FULL_SESSION
unset KDE_SESSION_VERSION
xprop -root -remove KDE_SESSION_VERSION
unset KDE_SESSION_UID

echo 'startkde: Done.'  1>&2
