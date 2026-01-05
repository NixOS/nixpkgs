{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libXt,
  libXext,
  libXpm,
  imake,
  gccmakedep,
  svgSupport ? false,
  librsvg,
  glib,
  gdk-pixbuf,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "xxkb";
  version = "1.11.1";

  src = fetchurl {
    url = "mirror://sourceforge/xxkb/xxkb-${version}-src.tar.gz";
    sha256 = "0hl1i38z9xnbgfjkaz04vv1n8xbgfg88g5z8fyzyb2hxv2z37anf";
  };

  nativeBuildInputs = [
    imake
    gccmakedep
    pkg-config
  ];

  buildInputs = [
    libX11
    libXt
    libXext
    libXpm
  ]
  ++ lib.optionals svgSupport [
    librsvg
    glib
    gdk-pixbuf
  ];

  outputs = [
    "out"
    "man"
  ];

  imakeFlags = lib.optionalString svgSupport "-DWITH_SVG_SUPPORT";

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "CONFDIR=${placeholder "out"}/etc/X11"
    "PIXMAPDIR=${placeholder "out"}/share/xxkb"
    "LIBDIR=${placeholder "out"}/lib/X11"
    "XAPPLOADDIR=${placeholder "out"}/etc/X11/app-defaults"
    "MANDIR=${placeholder "man"}/share/man"
  ];

  installTargets = [
    "install"
    "install.man"
  ];

  meta = with lib; {
    description = "Keyboard layout indicator and switcher";
    homepage = "http://xxkb.sourceforge.net/";
    license = licenses.artistic2;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "xxkb";
  };
}
