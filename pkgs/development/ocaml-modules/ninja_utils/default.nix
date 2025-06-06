{ lib, fetchzip, buildDunePackage, re }:

buildDunePackage rec {
  pname = "ninja_utils";
  version = "0.9.0";

  minimalOCamlVersion = "4.12";

  src = fetchzip {
    url = "https://github.com/CatalaLang/ninja_utils/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-VSj1IXfczoI3lSAtOqQPIqsxX+HgyxKzlssKd7By/Lo=";
  };

  propagatedBuildInputs = [ re ];

  meta = {
    description = "Small library used to generate Ninja build files";
    homepage = "https://github.com/CatalaLang/ninja_utils";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
