{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, patricia
, lib
, idris
}:
build-idris-package  {
  name = "semidirect";
  version = "2018-02-06";

  idrisDeps = [ prelude contrib patricia ];

  src = fetchFromGitHub {
    owner = "clayrat";
    repo = "idris-semidirect";
    rev = "884c26c095784f8fd489c323d6673f2a8710a741";
    sha256 = "0w36xkfxsqm6r91f0vs6qpmallrfwa09ql8i317xwm86nfk7akj9";
  };

  meta = {
    description = "Semidirect products in Idris";
    homepage = https://github.com/clayrat/idris-semidirect;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
