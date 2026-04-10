{
  build-idris-package,
  fetchFromGitHub,
  idrisscript,
  lib,
}:
build-idris-package {
  pname = "hrtime";
  version = "2017-04-16";

  ipkgName = "hrTime";
  idrisDeps = [ idrisscript ];

  src = fetchFromGitHub {
    owner = "pierrebeaucamp";
    repo = "idris-hrtime";
    rev = "e1f54ce74bde871010ae76d9afd42048cd2aae83";
    sha256 = "0rmmpi1kp1h7ficmcxbxkny9lq9pjli2qhwy17vgbgx8fx60m8l0";
  };

  meta = {
    description = "Idris library for high resolution time";
    homepage = "https://github.com/pierrebeaucamp/idris-hrtime";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
