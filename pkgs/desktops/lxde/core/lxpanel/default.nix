{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  pkg-config,
  gettext,
  m4,
  intltool,
  libxmlxx,
  keybinder,
  keybinder3,
  gtk2,
  gtk3,
  libX11,
  libfm,
  libwnck,
  libwnck2,
  libXmu,
  libXpm,
  cairo,
  gdk-pixbuf,
  gdk-pixbuf-xlib,
  menu-cache,
  lxmenu-data,
  wirelesstools,
  curl,
  supportAlsa ? false,
  alsa-lib,
  withGtk3 ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxpanel";
  version = "0.10.1";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-HjGPV9fja2HCOlBNA9JDDHja0ULBgERRBh8bPqVEHug=";
  };

  patches = [
    # fix build with gcc14
    # https://github.com/lxde/lxpanel/commit/0853b0fc981285ebd2ac52f8dfc2a09b1090748c
    (fetchpatch2 {
      url = "https://github.com/lxde/lxpanel/commit/0853b0fc981285ebd2ac52f8dfc2a09b1090748c.patch?full_index=1";
      hash = "sha256-lj4CWdiUQhEc9J8UNKcP7/tmsGnPjA5pwXAok5YFW4M=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    m4
    intltool
    libxmlxx
  ];
  buildInputs = [
    (if withGtk3 then keybinder3 else keybinder)
    (if withGtk3 then gtk3 else gtk2)
    libX11
    (libfm.override { inherit withGtk3; })
    (if withGtk3 then libwnck else libwnck2)
    libXmu
    libXpm
    cairo
    gdk-pixbuf
    gdk-pixbuf-xlib.dev
    menu-cache
    lxmenu-data
    m4
    wirelesstools
    curl
  ]
  ++ lib.optional supportAlsa alsa-lib;

  postPatch = ''
    substituteInPlace src/Makefile.in \
      --replace "@PACKAGE_CFLAGS@" "@PACKAGE_CFLAGS@ -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
    substituteInPlace plugins/Makefile.in \
      --replace "@PACKAGE_CFLAGS@" "@PACKAGE_CFLAGS@ -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
  '';

  configureFlags = lib.optional withGtk3 "--enable-gtk3";

  meta = {
    description = "Lightweight X11 desktop panel for LXDE";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.ryneeverett ];
    platforms = lib.platforms.linux;
  };
})
