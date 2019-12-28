{ buildPythonPackage, dbus-python, pygobject3, python-prctl, xscreensaver, xprintidle-ng }:

buildPythonPackage {
  pname = "gnome-xscreensaver";
  version = "0.1";
  src = ./.;

  postPatch = ''
    substituteInPlace gnomexscreensaver.py \
      --subst-var-by XSCREENSAVER_BIN ${xscreensaver}/bin/ \
      --subst-var-by XPRINTIDLE_BIN ${xprintidle-ng}/bin/
  '';

  propagatedBuildInputs = [ dbus-python pygobject3 python-prctl ];

  postInstall = ''
    mkdir -p $out/share/dbus-1/services
    cat > $out/share/dbus-1/services/org.gnome.ScreenSaver.service <<END_DESKTOP
    [D-BUS Service]
    Name=org.gnome.ScreenSaver
    Exec=$out/bin/gnome-screensaver
    END_DESKTOP

    cat > $out/share/dbus-1/services/org.freedesktop.ScreenSaver.service <<END_DESKTOP
    [D-BUS Service]
    Name=org.freedesktop.ScreenSaver
    Exec=$out/bin/gnome-screensaver
    END_DESKTOP

    mkdir -p $out/etc/xdg/autostart
    cat > $out/etc/xdg/autostart/gnome-screensaver <<END_DESKTOP
    [Desktop Entry]
    Type=Application
    Name=Screensaver
    Icon=preferences-desktop-screensaver
    Exec=$out/bin/gnome-screensaver
    OnlyShowIn=GNOME-Flashback;
    NoDisplay=true
    X-GNOME-Autostart-Phase=Application
    X-GNOME-Autostart-Notify=true
    END_DESKTOP
  '';
}