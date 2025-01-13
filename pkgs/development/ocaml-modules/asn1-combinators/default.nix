{
  lib,
  buildDunePackage,
  fetchurl,
  ptime,
  alcotest,
  ohex,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.13.0";

  pname = "asn1-combinators";
  version = "0.3.2";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v${version}/asn1-combinators-${version}.tbz";
    hash = "sha256-KyaYX24nIgc9zZ+ENVvWdX4SZDtaSOMLPAf/fPsNin8=";
  };

  propagatedBuildInputs = [ ptime ];

  doCheck = true;
  checkInputs = [ alcotest ohex ];

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-asn1-combinators";
    description = "Combinators for expressing ASN.1 grammars in OCaml";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
