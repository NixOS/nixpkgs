{ lib
, stdenv
, fetchurl
, libSM
, libX11
, libXt
, libffi
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "yabasic";
  version = "2.89.1";

  src = fetchurl {
    url = "http://www.yabasic.de/download/${pname}-${version}.tar.gz";
    hash = "sha256-k8QmQCpszLyotEiWDrG878RM2wqSq7I4W9j6Z2Ub3Yg=";
  };

  buildInputs = [
    libSM
    libX11
    libXt
    libffi
    ncurses
  ];

  meta = with lib; {
    homepage = "http://www.yabasic.de/";
    description = "Yet another BASIC";
    longDescription = ''
      Yabasic is a traditional basic-interpreter. It comes with goto and various
      loops and allows to define subroutines and libraries. It does simple
      graphics and printing. Yabasic can call out to libraries written in C and
      allows to create standalone programs. Yabasic runs under Unix and Windows
      and has a comprehensive documentation; it is small, simple, open-source
      and free.
   '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
