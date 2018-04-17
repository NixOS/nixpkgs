{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, lib
, idris
}:

build-idris-package  {
  name = "http4idris";
  version = "2018-01-16";

  idrisDeps = [ prelude contrib ];

  src = fetchFromGitHub {
    owner = "A1kmm";
    repo = "http4idris";
    rev = "f44ffd2a15628869c7aadf241e3c9b1ee7b40941";
    sha256 = "16bs7rxbsq7m7jm96zkqiq8hj68l907m8xgmjrcxzl158qvzhw1w";
  };

  meta = {
    description = "An experimental HTTP framework for Idris";
    homepage = https://github.com/A1kmm/http4idris;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
