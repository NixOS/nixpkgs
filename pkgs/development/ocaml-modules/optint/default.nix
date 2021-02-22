{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  minimumOCamlVersion = "4.03";
  version = "0.0.4";
  pname = "optint";
  src = fetchurl {
    url = "https://github.com/mirage/optint/releases/download/v${version}/optint-v${version}.tbz";
    sha256 = "1a7gabxqmfvii8qnxq1clx43md2h9glskxhac8y8r0rhzblx3s1a";
  };

  meta = {
    homepage = "https://github.com/mirage/optint";
    description = "Abstract type of integer between x64 and x86 architecture";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
