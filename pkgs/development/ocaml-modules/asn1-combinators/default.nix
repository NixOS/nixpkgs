{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ptime,
  alcotest,
  ohex,
}:

buildDunePackage (finalAttrs: {
  minimalOCamlVersion = "4.13.0";

  pname = "asn1-combinators";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mirleft";
    repo = "ocaml-asn1-combinators";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CN/9L24TmEDRWRI1IkbQzRvunMqx5vfukRO7JXmwc2E=";
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
