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
  version = "2.90.2";

  src = fetchurl {
    url = "http://www.yabasic.de/download/${pname}-${version}.tar.gz";
    hash = "sha256-ff5j0cJ1i2HWIsYjwzx5FFtZfchWsGRF2AZtbDXrNJw=";
  };

  buildInputs = [
    libSM
    libX11
    libXt
    libffi
    ncurses
  ];

  meta = with lib; {
    homepage = "http://2484.de/yabasic/";
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
