{ lib, fetchurl, buildDunePackage, ounit
, angstrom, stringext
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.03";
  pname = "uri";
  version = "4.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "13r9nkgym9z3dqxkyf0yyaqlrk5r3pjdw0kfzvrc90bmhwl9j380";
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
