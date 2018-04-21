{ build-idris-package
, fetchFromGitHub
, prelude
, lightyear
, lib
, idris
}:
build-idris-package  {
  name = "protobuf";
  version = "2017-08-12";

  idrisDeps = [ prelude lightyear ];

  src = fetchFromGitHub {
    owner = "artagnon";
    repo = "idris-protobuf";
    rev = "c21212534639518453d16ae1b0f07d94464ff8eb";
    sha256 = "0n5w7bdbxqca3b7hzg95md01mx4sfvl9fi82xjm0hzds33akmn05";
  };

  meta = {
    description = "A partial implementation of Protocol Buffers in Idris";
    homepage = https://github.com/artagnon/idris-protobuf;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
