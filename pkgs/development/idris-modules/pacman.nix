{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, sdl2
, lib
, idris
}:
build-idris-package  {
  name = "pacman";
  version = "2017-11-10";

  idrisDeps = [ prelude contrib sdl2 ];

  src = fetchFromGitHub {
    owner = "jdublu10";
    repo = "pacman";
    rev = "263ae58aeb5147e2af9cc76411970ccd90fa9121";
    sha256 = "02m3ic2fk3a8j50xdpq70yx30hkxzjg6idsia482sm1nlkmxxin9";
  };

  postUnpack = ''
    mv source/src/board.idr source/src/Board.idr
  '';

  meta = {
    description = "Proof that Idris is pacman complete";
    homepage = https://github.com/jdublu10/pacman;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
