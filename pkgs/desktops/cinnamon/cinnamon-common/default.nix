{ atk
, cacert
, fetchpatch
, dbus
, cinnamon-control-center
, cinnamon-desktop
, cinnamon-menus
, cinnamon-session
, cinnamon-translations
, cjs
, fetchFromGitHub
, gdk-pixbuf
, libgnomekbd
, glib
, gobject-introspection
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
, lib, stdenv
, wrapGAppsHook
, libxml2
, gtk-doc
, gnome
, python3
, keybinder3
, cairo
, xapps
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
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-common";
  version = "4.8.6";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    rev = version;
    hash = "sha256-4DMXQYH1/RjLhgrn55I7Vkk6+gGsR+OVmiwxVHUIyro=";
  };

  patches = [
    ./use-sane-install-dir.patch
    ./libdir.patch
  ];

  buildInputs = [
    # TODO: review if we really need this all
    (python3.withPackages (pp: with pp; [ dbus-python setproctitle pygobject3 pycairo xapp pillow pytz tinycss2 python-pam pexpect distro ]))
    atk
    cacert
    cinnamon-control-center
    cinnamon-desktop
    cinnamon-menus
    cjs
    dbus
    gdk-pixbuf
    glib
    gtk3
    json-glib
    libsoup
    libstartup_notification
    libXtst
    libXdamage
    muffin
    networkmanager
    pkg-config
    polkit
    libxml2
    libgnomekbd
    gst_all_1.gstreamer

    # bindings
    cairo
    gnome.caribou
    keybinder3
    upower
    xapps
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

    sed "s|/usr/bin/upload-system-info|${xapps}/bin/upload-system-info|g" -i ./files/usr/share/cinnamon/cinnamon-settings/modules/cs_info.py
    sed "s|upload-system-info|${xapps}/bin/upload-system-info|g" -i ./files/usr/share/cinnamon/cinnamon-settings/modules/cs_info.py

    sed "s|/usr/bin/cinnamon-control-center|${cinnamon-control-center}/bin/cinnamon-control-center|g" -i ./files/usr/bin/cinnamon-settings
    # this one really IS optional
    sed "s|/usr/bin/gnome-control-center|/run/current-system/sw/bin/gnome-control-center|g" -i ./files/usr/bin/cinnamon-settings

    sed "s|\"/usr/lib\"|\"${cinnamon-control-center}/lib\"|g" -i ./files/usr/share/cinnamon/cinnamon-settings/bin/capi.py

    # another bunch of optional stuff
    sed "s|/usr/bin|/run/current-system/sw/bin|g" -i ./files/usr/bin/cinnamon-launcher

    sed 's|"lspci"|"${pciutils}/bin/lspci"|g' -i ./files/usr/share/cinnamon/cinnamon-settings/modules/cs_info.py

    sed "s| cinnamon-session| ${cinnamon-session}/bin/cinnamon-session|g" -i ./files/usr/bin/cinnamon-session-cinnamon  -i ./files/usr/bin/cinnamon-session-cinnamon2d
    sed "s|/usr/bin|$out/bin|g" -i ./files/usr/share/xsessions/cinnamon.desktop ./files/usr/share/xsessions/cinnamon2d.desktop
  '';

  passthru = {
    providedSessions = ["cinnamon" "cinnamon2d"];
  };

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon";
    description = "The Cinnamon desktop environment";
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
