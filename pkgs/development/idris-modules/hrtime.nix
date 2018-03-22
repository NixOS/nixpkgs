{ build-idris-package
, fetchFromGitHub
, prelude
, idrisscript
, lib
, idris
}:
build-idris-package  {
  name = "hrtime";
  version = "2017-04-16";

  idrisDeps = [ prelude idrisscript ];

  src = fetchFromGitHub {
    owner = "pierrebeaucamp";
    repo = "idris-hrtime";
    rev = "e1f54ce74bde871010ae76d9afd42048cd2aae83";
    sha256 = "0rmmpi1kp1h7ficmcxbxkny9lq9pjli2qhwy17vgbgx8fx60m8l0";
  };

  meta = {
    description = "Idris library for high resolution time";
    homepage = https://github.com/pierrebeaucamp/idris-hrtime;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
