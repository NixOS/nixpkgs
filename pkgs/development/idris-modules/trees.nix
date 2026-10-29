{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  bi,
  lib,
}:
build-idris-package {
  pname = "trees";
  version = "2018-03-19";

  idrisDeps = [
    contrib
    bi
  ];

  src = fetchFromGitHub {
    owner = "clayrat";
    repo = "idris-trees";
    rev = "dc17f9598bd78ec2b283d91b3c58617960d88c85";
    hash = "sha256-nHf+xiYf+GFerPj2yp5UhvBfyO+pRiRm+4ThclAyd7A=";
  };

  meta = {
    description = "Trees in Idris";
    homepage = "https://github.com/clayrat/idris-trees";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
