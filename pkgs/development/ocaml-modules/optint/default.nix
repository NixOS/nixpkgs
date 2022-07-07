{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  minimalOCamlVersion = "4.07";
  version = "0.2.0";
  pname = "optint";
  src = fetchurl {
    url = "https://github.com/mirage/optint/releases/download/v${version}/optint-${version}.tbz";
    sha256 = "sha256-HcvgtrYDH3fbMwKMhxOP2zv5D5KRXjtmKd3rMKDTAAs=";
  };

  meta = {
    homepage = "https://github.com/mirage/optint";
    description = "Abstract type of integer between x64 and x86 architecture";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
