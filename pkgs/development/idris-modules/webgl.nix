{ build-idris-package
, fetchFromGitHub
, prelude
, idrisscript
, lib
, idris
}:
build-idris-package  {
  name = "webgl";
  version = "2017-05-08";

  idrisDeps = [ prelude idrisscript ];

  src = fetchFromGitHub {
    owner = "pierrebeaucamp";
    repo = "idris-webgl";
    rev = "1b4ee00a06b0bccfe33eea0fa8f068cdae690e9e";
    sha256 = "097l2pj8p33d0n3ryb8y2vp0n5isnc8bkdnad3y6raa9z1xjn3d6";
  };

  meta = {
    description = "Idris library to interact with WebGL";
    homepage = https://github.com/pierrebeaucamp/idris-webgl;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
