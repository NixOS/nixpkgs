{ build-idris-package
, fetchFromGitHub
, prelude
, effects
, lib
, idris
, ncurses
}:
build-idris-package  {
  name = "curses";
  version = "2017-10-12";

  idrisDeps = [ prelude effects ];

  extraBuildInputs = [ ncurses.out ncurses.dev ];

  postUnpack = ''
    sed -i 's/^libs = curses$/libs = ncurses/g' source/curses.ipkg
    sed -i 's/\#include <curses.h>/#include \<ncurses.h\>/g' source/src/cursesrun.h
  '';

  src = fetchFromGitHub {
    owner = "JakobBruenker";
    repo = "curses-idris";
    rev = "ea4bbcfcf691f0dc731f2dfa676011809db084cb";
    sha256 = "17q8hg5f61lk2kh3j4cwrwja282sihlcjdrx233z4237alp9w4g1";
  };

  meta = {
    description = "libusb binding for idris and Effectful curses programming";
    homepage = https://github.com/JakobBruenker/curses-idris;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
