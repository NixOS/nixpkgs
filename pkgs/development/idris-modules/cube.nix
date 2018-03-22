{ build-idris-package
, fetchFromGitHub
, prelude
, base
, lib
, idris
}:

build-idris-package  {
  name = "cube";
  version = "2017-07-05";

  idrisDeps = [ prelude base ];

  src = fetchFromGitHub {
    owner = "aatxe";
    repo = "cube.idr";
    rev = "edf66d82b3a363dc65c6f5416c9e24e746bad71e";
    sha256 = "11k45j0b4qabj6zhwjvynyj56nmssf7d4fnkv66bd2w1pxnshzxg";
  };

  meta = {
    description = "An implementation of the Lambda Cube in Idris";
    homepage = https://github.com/aatxe/cube.idr;
    license = lib.licenses.agpl3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
