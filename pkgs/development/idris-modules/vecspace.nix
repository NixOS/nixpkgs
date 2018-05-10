{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, lib
, idris
}:
build-idris-package  {
  name = "vecspace";
  version = "2018-01-12";

  idrisDeps = [ prelude contrib ];

  src = fetchFromGitHub {
    owner = "clayrat";
    repo = "idris-vecspace";
    rev = "6830fa13232f25e9874b3f857b79508b5f82cb99";
    sha256 = "1dwz69cmzblyh7lnyqq2gp0a042z7h02sh5q5wf4xb500vizwkq2";
  };

  meta = {
    description = "Abstract vector spaces in Idris";
    homepage = https://github.com/clayrat/idris-vecspace;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
