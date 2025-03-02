{
  lib,
  autoreconfHook,
  curl,
  fetchhg,
  libXext,
  libXft,
  libXi,
  libXinerama,
  libXtst,
  libXv,
  libXxf86vm,
  libjpeg,
  libpng,
  lirc,
  ncurses,
  perl,
  pkg-config,
  readline,
  shared-mime-info,
  stdenv,
  xine-lib,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xine-ui";
  version = "0.99.14-unstable-2024-08-26";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/xine/xine-ui";
    rev = "2beaad6bb92e6732585f68af2e346a24e5ad53a5";
    hash = "sha256-Y08JX9q4w6pSJRCa5mWN11BnA6mZJSO/yn3X8YyZ6E4=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    shared-mime-info
    perl
  ];

  buildInputs = [
    curl
    libXext
    libXft
    libXi
    libXinerama
    libXtst
    libXv
    libXxf86vm
    libjpeg
    libpng
    lirc
    ncurses
    readline
    xine-lib
    xorgproto
  ];

  configureFlags = [ "--with-readline=${readline.dev}" ];

  env = {
    LIRC_CFLAGS = "-I${lib.getInclude lirc}/include";
    LIRC_LIBS = "-L ${lib.getLib lirc}/lib -llirc_client";
  };

  strictDeps = true;

  meta = {
    homepage = "https://xine.sourceforge.net/";
    description = "Xlib-based frontend for Xine video player";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xine";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
