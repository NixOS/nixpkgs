{ lib, fetchurl, buildDunePackage, ounit
, angstrom, stringext
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.03";
  pname = "uri";
  version = "4.4.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "0szifda6yism5vn5jdizkha3ad0xk6zw4xgfl8g77dnv83ci7h65";
  };

  checkInputs = [ ounit ];
  propagatedBuildInputs = [ angstrom stringext ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/ocaml-uri";
    description = "RFC3986 URI parsing library for OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
