{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "cube";
  version = "2017-07-05";

  src = fetchFromGitHub {
    owner = "aatxe";
    repo = "cube.idr";
    rev = "edf66d82b3a363dc65c6f5416c9e24e746bad71e";
    hash = "sha256-r3+obb+Bi7aM2dM60o7TulpTpLd+Sw6/kUthsoAsZIY=";
  };

  meta = {
    description = "Implementation of the Lambda Cube in Idris";
    homepage = "https://github.com/aatxe/cube.idr";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
