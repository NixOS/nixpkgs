{ lib, buildDunePackage, fetchurl
, cstruct, zarith, bigarray-compat, stdlib-shims, ptime, alcotest
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  pname = "asn1-combinators";
  version = "0.2.6";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v${version}/asn1-combinators-v${version}.tbz";
    sha256 = "sha256-ASreDYhp72IQY3UsHPjqAm9rxwL+0Q35r1ZojikbGpE=";
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
