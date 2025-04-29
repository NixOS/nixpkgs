{
  build-idris-package,
  fetchFromGitHub,
  effects,
  containers,
  lightyear,
  test,
  lib,
}:
build-idris-package {
  pname = "config";
  version = "2017-11-06";

  idrisDeps = [
    effects
    containers
    lightyear
    test
  ];

  src = fetchFromGitHub {
    owner = "benclifford";
    repo = "idris-config";
    rev = "92f98652f5cb06a76c47809f16c661ec6cf11048";
    sha256 = "1w2w2l4drvkf8mdzh3lwn6l5lnkbxlx9p22s7spw82n5s4wib6c9";
  };

  meta = {
    description = "Parsers for various configuration files written in Idris";
    homepage = "https://github.com/benclifford/idris-config";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
