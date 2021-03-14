{ lib, buildDunePackage, fetchurl
, cstruct, zarith, bigarray-compat, stdlib-shims, ptime, alcotest
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.05";

  pname = "asn1-combinators";
  version = "0.2.5";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v${version}/asn1-combinators-v${version}.tbz";
    sha256 = "1pbcdwm12hnfpd1jv2b7cjfkj5r7h61xp2gr8dysb8waa455kwln";
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
