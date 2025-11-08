{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "http4idris";
  version = "2018-01-16";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "A1kmm";
    repo = "http4idris";
    rev = "f44ffd2a15628869c7aadf241e3c9b1ee7b40941";
    sha256 = "16bs7rxbsq7m7jm96zkqiq8hj68l907m8xgmjrcxzl158qvzhw1w";
  };

  meta = {
    description = "Experimental HTTP framework for Idris";
    homepage = "https://github.com/A1kmm/http4idris";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
