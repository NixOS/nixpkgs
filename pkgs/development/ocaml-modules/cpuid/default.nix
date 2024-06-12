{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "cpuid";
  version = "0.1.2";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/pqwy/cpuid/releases/download/v${version}/cpuid-v${version}.tbz";
    sha256 = "08ng4mva6qblb5ipkrxbr0my7ndkc4qwcbswkqgbgir864s74m93";
  };

  meta = {
    homepage = "https://github.com/pqwy/cpuid";
    description = "Detect CPU features from OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
