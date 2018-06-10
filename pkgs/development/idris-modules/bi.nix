{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, pruviloj
, lib
, idris
}:
build-idris-package  {
  name = "bi";
  version = "2018-01-17";

  idrisDeps = [ prelude contrib pruviloj ];

  src = fetchFromGitHub {
    owner = "sbp";
    repo = "idris-bi";
    rev = "8ab40bc482ca948ac0f6ffb5b4c545a73688dd3a";
    sha256 = "1lra945q2d6anwzjs94srprqj867lrz66rsns08p8828vg55fv97";
  };

  meta = {
    description = "Idris Binary Integer Arithmetic, porting PArith, NArith, and ZArith from Coq";
    homepage = https://github.com/sbp/idris-bi;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
