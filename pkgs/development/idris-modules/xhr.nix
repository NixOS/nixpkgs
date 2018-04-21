{ build-idris-package
, fetchFromGitHub
, prelude
, idrisscript
, lib
, idris
}:
build-idris-package  {
  name = "xhr";
  version = "2017-04-22";

  idrisDeps = [ prelude idrisscript ];

  src = fetchFromGitHub {
    owner = "pierrebeaucamp";
    repo = "idris-xhr";
    rev = "fb32a748ccdb9070de3f2d6048564e34c064b362";
    sha256 = "0l07mnarvrb4xdw0b2xqgyxq4rljw1axz5mc9w4gmhvcrzxnyfnr";
  };

  meta = {
    description = "Idris library to interact with xhr";
    homepage = https://github.com/pierrebeaucamp/idris-xhr;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
