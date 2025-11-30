{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  findlib,
  alcotest,
  bos,
  rresult,
}:

buildDunePackage rec {
  pname = "base64";
  version = "3.5.2";

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-base64/releases/download/v${version}/base64-${version}.tbz";
    hash = "sha256-s/XOMBqnLHAy75C+IzLXL/OWKSLADuKuxryt4Yei9Zs=";
  };

  nativeBuildInputs = [ findlib ];

  # otherwise fmt breaks evaluation
  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [
    alcotest
    bos
    rresult
  ];

  meta = {
    homepage = "https://github.com/mirage/ocaml-base64";
    description = "Base64 encoding and decoding in OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
