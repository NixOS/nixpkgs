{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  minimumOCamlVersion = "4.03";
  version = "0.0.3";
  pname = "optint";
  src = fetchurl {
    url = "https://github.com/mirage/optint/releases/download/v${version}/optint-v${version}.tbz";
    sha256 = "0c7r3s6lal9xkixngkj25nqncj4s33ka40bjdi7fz7mly08djycj";
  };

  meta = {
    homepage = "https://github.com/mirage/optint";
    description = "Abstract type of integer between x64 and x86 architecture";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
