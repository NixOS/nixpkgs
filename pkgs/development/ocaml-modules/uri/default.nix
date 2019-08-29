{ lib, fetchurl, buildDunePackage, ounit
, re, stringext
}:

buildDunePackage rec {
  pname = "uri";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "1yhrgm3hbn0hh4jdmcrvxinazgg8vrm0vn425sg8ggzblvxk9cwg";
  };

  buildInputs = [ ounit ];
  propagatedBuildInputs = [ re stringext ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/ocaml-uri";
    description = "RFC3986 URI parsing library for OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
