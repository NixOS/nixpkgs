{
  lib,
  stdenv,
  fetchurl,
  libSM,
  libX11,
  libXt,
  libffi,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yabasic";
  version = "2.90.4";

  src = fetchurl {
    url = "http://www.yabasic.de/download/yabasic-${finalAttrs.version}.tar.gz";
    hash = "sha256-td54SC1LnO3z07m3BsVDpiAsmokzB4xn4dbVdfeYH8M=";
  };

  buildInputs = [
    libSM
    libX11
    libXt
    libffi
    ncurses
  ];

  meta = {
    homepage = "http://2484.de/yabasic/";
    description = "Yet another BASIC";
    mainProgram = "yabasic";
    longDescription = ''
      Yabasic is a traditional basic-interpreter. It comes with goto and various
      loops and allows to define subroutines and libraries. It does simple
      graphics and printing. Yabasic can call out to libraries written in C and
      allows to create standalone programs. Yabasic runs under Unix and Windows
      and has a comprehensive documentation; it is small, simple, open-source
      and free.
    '';
    changelog = "https://2484.de/yabasic/whatsnew.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
