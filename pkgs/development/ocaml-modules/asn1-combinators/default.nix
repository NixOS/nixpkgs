{ lib, buildDunePackage, fetchurl
, cstruct, zarith, bigarray-compat, stdlib-shims, ptime, alcotest
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.05";

  pname = "asn1-combinators";
  version = "0.2.4";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v${version}/asn1-combinators-v${version}.tbz";
    sha256 = "09rn5wwqhwg7x51b9ycl15s7007hgha6lwaz2bpw85fr70jq3i9r";
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
