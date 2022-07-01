{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";
  version = "0.1.0";
  pname = "optint";
  src = fetchurl {
    url = "https://github.com/mirage/optint/releases/download/v${version}/optint-v${version}.tbz";
    sha256 = "27847660223c16cc7eaf8fcd9d5589a0b802114330a2529578f8007d3b01185d";
  };

  useDune2 = true;

  meta = {
    homepage = "https://github.com/mirage/optint";
    description = "Abstract type of integer between x64 and x86 architecture";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
