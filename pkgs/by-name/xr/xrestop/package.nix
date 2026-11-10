{
  lib,
  stdenv,
  fetchurl,
  libxres,
  libxext,
  libx11,
  pkg-config,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrestop";
  version = "0.6";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/xrestop-${finalAttrs.version}.tar.xz";
    hash = "sha256-Li7BEcSyeYtdwtwrPsevT2smGUbpA7jhTbBGgx0gOyk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    libxres
    libxext
    ncurses
  ];

  meta = {
    description = "'top' like tool for monitoring X Client server resource usage";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xrestop";
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    mainProgram = "xrestop";
  };
})
