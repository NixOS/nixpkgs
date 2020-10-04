{ atk
, autoreconfHook
, cacert
, fetchpatch
, dbus
, cinnamon-control-center
, cinnamon-desktop
, cinnamon-menus
, cinnamon-session
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
, muffin
, networkmanager
, pkgconfig
, polkit
, stdenv
, wrapGAppsHook
, libxml2
, gtk-doc
, gnome3
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
}:

let
  libcroco = callPackage ./libcroco.nix { };
in
stdenv.mkDerivation rec {
  pname = "cinnamon-common";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    rev = version;
    sha256 = "149lhg953fa0glm250f76z2jzyaabh97jxiqkjnqvsk6bjk1d0bw";
  };

  patches = [
    # remove dbus-glib
    (fetchpatch {
      url = "https://github.com/linuxmint/cinnamon/commit/ce99760fa15c3de2e095b9a5372eeaca646fbed1.patch";
      sha256 = "0p2sbdi5w7sgblqbgisb6f8lcj1syzq5vlk0ilvwaqayxjylg8gz";
    })
    (fetchpatch {
      url = "https://leigh123linux.fedorapeople.org/pub/patches/new_cjs.patch";
      sha256 = "07biv3vkbn3jzijbdrxcw73p8xz2djbsax014mlkvmryrmys0rg4";
    })
  ];

  buildInputs = [
    # TODO: review if we really need this all
    (python3.withPackages (pp: with pp; [ dbus-python setproctitle pygobject3 pycairo xapp pillow pytz tinycss2 pam pexpect distro ]))
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
    libcroco
    libsoup
    libstartup_notification
    libXtst
    muffin
    networkmanager
    pkgconfig
    polkit
    libxml2
    libgnomekbd

    # bindings
    cairo
    gnome3.caribou
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
    autoreconfHook
    wrapGAppsHook
    intltool
    gtk-doc
  ];

  autoreconfPhase = ''
    GTK_DOC_CHECK=false NOCONFIGURE=1 bash ./autogen.sh
  '';

  configureFlags = [ "--disable-static" "--with-ca-certificates=${cacert}/etc/ssl/certs/ca-bundle.crt" "--with-libxml=${libxml2.dev}/include/libxml2" "--enable-gtk-doc=no" ];

  postPatch = ''
    substituteInPlace src/Makefile.am \
      --replace "\$(libdir)/muffin" "${muffin}/lib/muffin"
    patchShebangs autogen.sh

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

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon";
    description = "The Cinnamon desktop environment";
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
