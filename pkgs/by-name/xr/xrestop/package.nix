{
  lib,
  stdenv,
  fetchurl,
  xorg,
  pkg-config,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "xrestop";
  version = "0.6";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/xrestop-${version}.tar.xz";
    hash = "sha256-Li7BEcSyeYtdwtwrPsevT2smGUbpA7jhTbBGgx0gOyk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11
    xorg.libXres
    xorg.libXext
    ncurses
  ];

<<<<<<< HEAD
  meta = {
    description = "'top' like tool for monitoring X Client server resource usage";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xrestop";
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "'top' like tool for monitoring X Client server resource usage";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xrestop";
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "xrestop";
  };
}
