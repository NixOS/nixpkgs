{ lib, fetchurl, buildDunePackage, cstruct, bigarray-compat, ounit }:

buildDunePackage rec {
  pname = "io-page";
  version = "2.4.0";

  minimalOCamlVersion = "4.02.3";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "sha256-gMr0AfnDifHM912TstgkI+Q0FxB1rAyb0Abfospt9EI=";
  };

  propagatedBuildInputs = [ cstruct bigarray-compat ];
  checkInputs = [ ounit ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/io-page";
    license = lib.licenses.isc;
    description = "IO memory page library for Mirage backends";
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
