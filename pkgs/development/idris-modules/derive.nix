{ build-idris-package
, fetchFromGitHub
, prelude
, contrib
, pruviloj
, lib
, idris
}:
build-idris-package  {
  name = "derive";
  version = "2018-02-15";

  idrisDeps = [ prelude contrib pruviloj ];

  src = fetchFromGitHub {
    owner = "davlum";
    repo = "derive-all-the-instances";
    rev = "2c8956807bd094ba33569227de921c6726401c42";
    sha256 = "0l7263s04r52ql292vnnx2kngld6s1dipmaz5na7m82lj9p4x17y";
  };

  meta = {
    description = "Type class deriving with elaboration reflection";
    homepage = https://github.com/davlum/derive-all-the-instances;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
