{
  lib,
  buildDunePackage,
  fetchurl,
  containers,
  junit_alcotest,
  astring,
  base64,
  x509,
  yojson,
  zarith,
}:

buildDunePackage (finalAttrs: {
  pname = "jose";
  version = "0.11.0";

  src = fetchurl {
    url = "https://github.com/ulrikstrid/ocaml-jose/releases/download/${finalAttrs.version}/jose-${finalAttrs.version}.tbz";
    hash = "sha256-fg0HLIb5caJw7p1kL6TYzPLijhdoqlbrm3NvoUBBQXQ=";
  };

  propagatedBuildInputs = [
    astring
    base64
    x509
    yojson
    zarith
  ];

  doCheck = true;
  checkInputs = [
    containers
    junit_alcotest
  ];

  meta = {
    description = "JOSE specification implementation in OCaml";
    homepage = "https://github.com/ulrikstrid/ocaml-jose";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ulrikstrid
      toastal
      marijanp
    ];
  };
})
