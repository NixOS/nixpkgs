{ lib, fetchurl, buildDunePackage, re }:

buildDunePackage rec {
  pname = "ninja_utils";
  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/CatalaLang/ninja_utils/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-ZYxSrTA6BUN3OEDq4sLv9bMAgsL6z97GpGFG5w96OvY=";
  };

  propagatedBuildInputs = [ re ];

  meta = {
    description = "Small library used to generate Ninja build files";
    homepage = "https://github.com/CatalaLang/ninja_utils";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
