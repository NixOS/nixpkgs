{ lib, buildDunePackage, fetchurl
, cstruct, zarith, bigarray-compat, stdlib-shims, ptime, alcotest
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.05";

  pname = "asn1-combinators";
  version = "0.2.3";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v${version}/asn1-combinators-v${version}.tbz";
    sha256 = "1z73hc17f5m2i4bfxw0g94fsri67f8vha812mm8klz4ggs8y7d6r";
  };

  propagatedBuildInputs = [ cstruct zarith bigarray-compat stdlib-shims ptime ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-asn1-combinators";
    description = "Combinators for expressing ASN.1 grammars in OCaml";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
