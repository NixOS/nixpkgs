{
  lib,
  buildDunePackage,
  fetchurl,
  ptime,
  alcotest,
  ohex,
}:

buildDunePackage (finalAttrs: {
  minimalOCamlVersion = "4.13.0";

  pname = "asn1-combinators";
  version = "0.3.2";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v${finalAttrs.version}/asn1-combinators-${finalAttrs.version}.tbz";
    hash = "sha256-KyaYX24nIgc9zZ+ENVvWdX4SZDtaSOMLPAf/fPsNin8=";
  };

  propagatedBuildInputs = [ ptime ];

  doCheck = true;
  checkInputs = [
    alcotest
    ohex
  ];

  meta = {
    homepage = "https://github.com/mirleft/ocaml-asn1-combinators";
    changelog = "https://github.com/mirleft/ocaml-asn1-combinators/blob/v${finalAttrs.version}/CHANGES.md";
    description = "Combinators for expressing ASN.1 grammars in OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})
