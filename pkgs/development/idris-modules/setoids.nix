{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "setoids";
  version = "2018-06-18";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "danilkolikov";
    repo = "setoids";
    rev = "41b4af3b1a537d9471107a639ad77c7abee2de18";
    hash = "sha256-O9j46addbhXFxZWl2+1I6sgjNrNFX3pty3aboFN5gTo=";
  };

  meta = {
    description = "Idris proofs for extensional equalities";
    homepage = "https://github.com/danilkolikov/setoids";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
