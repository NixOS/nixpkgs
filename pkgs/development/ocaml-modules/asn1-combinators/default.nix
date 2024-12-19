{
  lib,
  buildDunePackage,
  fetchurl,
  ptime,
  alcotest,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";

  pname = "asn1-combinators";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v${version}/asn1-combinators-${version}.tbz";
    hash = "sha256-+imExupuHhxP4gM/AWWvYRljwkAM4roFEAS3ffxVfE4=";
  };

  propagatedBuildInputs = [ ptime ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-asn1-combinators";
    description = "Combinators for expressing ASN.1 grammars in OCaml";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
