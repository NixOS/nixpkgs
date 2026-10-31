{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "tap";
  version = "2017-04-08";

  ipkgName = "TAP";
  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "ostera";
    repo = "tap-idris";
    rev = "0d019333e1883c1d60e151af1acb02e2b531e72f";
    hash = "sha256-uv8EKc1s8+cp8gfy8a9aRwavdoU203tyQrsnvGOtFDo=";
  };

  meta = {
    description = "Simple TAP producer and consumer/reporter for Idris";
    homepage = "https://github.com/ostera/tap-idris";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
