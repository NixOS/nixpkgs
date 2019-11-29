{ atk,
  autoreconfHook,
  cacert,
  cinnamon-desktop,
  cinnamon-menus,
  cjs,
  dbus-glib,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  intltool,
  json-glib,
  libcroco,
  libsoup,
  libstartup_notification,
  libXtst,
  muffin,
  networkmanager,
  pkgconfig,
  polkit,
  stdenv,
  wrapGAppsHook,
  libxml2,
  gnome2,
  python3,
  keybinder3 }:

stdenv.mkDerivation rec {
  pname = "cinnamon-common";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    rev = version;
    sha256 = "0sv7nqd1l6c727qj30dcgdkvfh1wxpszpgmbdyh58ilmc8xklnqd";
  };

  buildInputs = [ # TODO: review if we really need this all
    (python3.withPackages (pp: with pp; [ setproctitle pygobject3 ]))
    atk
    cacert
    cinnamon-desktop
    cinnamon-menus
    cjs
    dbus-glib
    gdk-pixbuf
    glib
    gtk3
    json-glib
    libcroco
    libsoup
    libstartup_notification
    libXtst muffin
    networkmanager
    pkgconfig
    polkit
    libxml2
    keybinder3
  ];
  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook
    intltool
    gnome2.gtkdoc
    gobject-introspection
  ];

  autoreconfPhase = ''
    GTK_DOC_CHECK=false NOCONFIGURE=1 bash ./autogen.sh
    '';

  configureFlags = [ "--disable-static" "--with-ca-certificates=${cacert}/etc/ssl/certs/ca-bundle.crt" "--with-libxml=${libxml2.dev}/include/libxml2" "--enable-gtk-doc=no" ];

  postPatch = ''
    substituteInPlace src/Makefile.am \
      --replace "\$(libdir)/muffin" "${muffin}/lib/muffin"
    patchShebangs autogen.sh
  '';
}
