{ atk
, cacert
, dbus
, cinnamon-control-center
, cinnamon-desktop
, cinnamon-menus
, cinnamon-session
, cinnamon-translations
, cjs
, clutter
, fetchFromGitHub
, gdk-pixbuf
, gettext
, libgnomekbd
, glib
, gobject-introspection
, gsound
, gtk3
, intltool
, json-glib
, callPackage
, libsoup
, libstartup_notification
, libXtst
, libXdamage
, muffin
, networkmanager
, pkg-config
, polkit
, lib
, stdenv
, wrapGAppsHook
, libxml2
, gtk-doc
, gnome
, python3
, keybinder3
, cairo
, xapp
, upower
, nemo
, libnotify
, accountsservice
, gnome-online-accounts
, glib-networking
, pciutils
, timezonemap
, libnma
, meson
, ninja
, gst_all_1
, perl
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-common";
  version = "5.4.12";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    rev = version;
    hash = "sha256-uyQZXri3V3dKnowB97QlPWboZz1neblyvCuSacsPROg=";
  };

  patches = [
    ./use-sane-install-dir.patch
    ./libdir.patch
  ];

  buildInputs = [
    (python3.withPackages (pp: with pp; [
      dbus-python
      setproctitle
      pygobject3
      pycairo
      python3.pkgs.xapp # The scope prefix is required
      pillow
      pyinotify # for looking-glass
      pytz
      tinycss2
      python-pam
      pexpect
      distro
      requests
    ]))
    atk
    cacert
    cinnamon-control-center
    cinnamon-desktop
    cinnamon-menus
    cjs
    clutter
    dbus
    gdk-pixbuf
    glib
    gsound
    gtk3
    json-glib
    libsoup # referenced in js/ui/environment.js
    libstartup_notification
    libXtst
    libXdamage
    muffin
    networkmanager
    polkit
    libxml2
    libgnomekbd
    gst_all_1.gstreamer

    # bindings
    cairo
    gnome.caribou
    keybinder3
    upower
    xapp
    timezonemap
    nemo
    libnotify
    accountsservice
    libnma

    # gsi bindings
    gnome-online-accounts
    glib-networking # for goa
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    wrapGAppsHook
    intltool
    gtk-doc
    perl
    python3.pkgs.wrapPython
    pkg-config
  ];

  # use locales from cinnamon-translations (not using --localedir because datadir is used)
  postInstall = ''
    ln -s ${cinnamon-translations}/share/locale $out/share/locale
  '';

  postPatch = ''
    find . -type f -exec sed -i \
      -e s,/usr/share/cinnamon,$out/share/cinnamon,g \
      -e s,/usr/share/locale,/run/current-system/sw/share/locale,g \
      {} +

    sed "s|/usr/share/sounds|/run/current-system/sw/share/sounds|g" -i ./files/usr/share/cinnamon/cinnamon-settings/bin/SettingsWidgets.py

    sed "s|/usr/share/%s|/run/current-system/sw/share/%s|g" -i ./files/usr/share/cinnamon/cinnamon-settings/modules/cs_themes.py

    sed "s|/usr/bin/upload-system-info|${xapp}/bin/upload-system-info|g" -i ./files/usr/share/cinnamon/cinnamon-settings/modules/cs_info.py
    sed "s|\"upload-system-info\"|\"${xapp}/bin/upload-system-info\"|g" -i ./files/usr/share/cinnamon/cinnamon-settings/modules/cs_info.py

    sed "s|/usr/bin/cinnamon-control-center|${cinnamon-control-center}/bin/cinnamon-control-center|g" -i ./files/usr/bin/cinnamon-settings

    sed "s|/usr/bin/cinnamon-screensaver-command|/run/current-system/sw/bin/cinnamon-screensaver-command|g" \
      -i ./files/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js -i ./files/usr/share/cinnamon/applets/user@cinnamon.org/applet.js

    # this one really IS optional
    sed "s|/usr/bin/gnome-control-center|/run/current-system/sw/bin/gnome-control-center|g" -i ./files/usr/bin/cinnamon-settings

    sed "s|\"/usr/lib\"|\"${cinnamon-control-center}/lib\"|g" -i ./files/usr/share/cinnamon/cinnamon-settings/bin/capi.py

    # another bunch of optional stuff
    sed "s|/usr/bin|/run/current-system/sw/bin|g" -i ./files/usr/bin/cinnamon-launcher

    sed 's|"lspci"|"${pciutils}/bin/lspci"|g' -i ./files/usr/share/cinnamon/cinnamon-settings/modules/cs_info.py

    sed "s| cinnamon-session| ${cinnamon-session}/bin/cinnamon-session|g" -i ./files/usr/bin/cinnamon-session-cinnamon  -i ./files/usr/bin/cinnamon-session-cinnamon2d
    sed "s|/usr/bin|$out/bin|g" -i ./files/usr/share/xsessions/cinnamon.desktop ./files/usr/share/xsessions/cinnamon2d.desktop ./files/usr/share/applications/cinnamon2d.desktop

    # Only needed for cinnamon <= 5.4.12
    sed "s|/usr/bin|$out/bin|g" -i ./files/usr/share/dbus-1/services/org.Cinnamon.Melange.service

    sed "s|msgfmt|${gettext}/bin/msgfmt|g" -i ./files/usr/share/cinnamon/cinnamon-settings/bin/Spices.py

    patchShebangs src/data-to-c.pl
  '';

  preFixup = ''
    # https://github.com/NixOS/nixpkgs/issues/101881
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome.caribou}/share"
    )

    # https://github.com/NixOS/nixpkgs/issues/129946
    buildPythonPath "${python3.pkgs.xapp}"
    patchPythonScript $out/share/cinnamon/cinnamon-desktop-editor/cinnamon-desktop-editor.py
  '';

  passthru = {
    providedSessions = [ "cinnamon" "cinnamon2d" ];
  };

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon";
    description = "The Cinnamon desktop environment";
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
