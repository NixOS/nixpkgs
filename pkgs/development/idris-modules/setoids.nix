{ build-idris-package
, fetchFromGitHub
, prelude
, lib
, idris
}:
build-idris-package  {
  name = "setoids";
  version = "2017-03-13";

  idrisDeps = [ prelude ];

  src = fetchFromGitHub {
    owner = "danilkolikov";
    repo = "setoids";
    rev = "a50cfc010cb4321cc9b7988c0a4f387d83d34839";
    sha256 = "0q0h2qj9vylkm16h70l78l2p5xjkx4qmg2a2ixfl8vq8b1zm8gch";
  };

  meta = {
    description = "Idris proofs for extensional equalities";
    homepage = https://github.com/danilkolikov/setoids;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
