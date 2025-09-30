{
  writeText,
  writeScriptBin,
  xorg,
  xkeyboard_config,
  runtimeShell,
  unfreeFonts ? false,
  lib,
}:

let
  xorgConfig = writeText "dummy-xorg.conf" ''
    Section "ServerLayout"
      Identifier     "dummy_layout"
      Screen         0 "dummy_screen"
      InputDevice    "dummy_keyboard" "CoreKeyboard"
      InputDevice    "dummy_mouse" "CorePointer"
    EndSection

    Section "ServerFlags"
      Option "DontVTSwitch" "true"
      Option "AllowMouseOpenFail" "true"
      Option "PciForceNone" "true"
      Option "AutoEnableDevices" "false"
      Option "AutoAddDevices" "false"
    EndSection

    Section "Files"
      ModulePath "${xorg.xorgserver.out}/lib/xorg/modules"
      ModulePath "${xorg.xf86videodummy}/lib/xorg/modules"
      XkbDir "${xkeyboard_config}/share/X11/xkb"
      FontPath "${xorg.fontadobe75dpi}/share/fonts/X11/75dpi"
      FontPath "${xorg.fontadobe100dpi}/share/fonts/X11/100dpi"
      FontPath "${xorg.fontmiscmisc}/lib/X11/fonts/misc"
      FontPath "${xorg.fontcursormisc}/lib/X11/fonts/misc"
    ${lib.optionalString unfreeFonts ''
      FontPath "${xorg.fontbhlucidatypewriter75dpi}/lib/X11/fonts/75dpi"
      FontPath "${xorg.fontbhlucidatypewriter100dpi}/lib/X11/fonts/100dpi"
      FontPath "${xorg.fontbh100dpi}/lib/X11/fonts/100dpi"
    ''}
    EndSection

    Section "Module"
      Load           "dbe"
      Load           "extmod"
      Load           "freetype"
      Load           "glx"
    EndSection

    Section "InputDevice"
      Identifier     "dummy_mouse"
      Driver         "void"
    EndSection

    Section "InputDevice"
      Identifier     "dummy_keyboard"
      Driver         "void"
    EndSection

    Section "Monitor"
      Identifier     "dummy_monitor"
      HorizSync       30.0 - 130.0
      VertRefresh     50.0 - 250.0
      Option         "DPMS"
    EndSection

    Section "Device"
      Identifier     "dummy_device"
      Driver         "dummy"
      VideoRam       192000
    EndSection

    Section "Screen"
      Identifier     "dummy_screen"
      Device         "dummy_device"
      Monitor        "dummy_monitor"
      DefaultDepth    24
      SubSection     "Display"
        Depth       24
        Modes      "1280x1024"
      EndSubSection
    EndSection
  '';

in
writeScriptBin "xdummy" ''
  #!${runtimeShell}
  exec ${xorg.xorgserver.out}/bin/Xorg \
    -noreset \
    -logfile /dev/null \
    "$@" \
    -config "${xorgConfig}"
''
