{ lib, fetchurl, buildDunePackage, ocaml, findlib, alcotest, bos, rresult }:

buildDunePackage rec {
  pname = "base64";
  version = "3.5.1";

  minimalOCamlVersion = "4.03";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-base64/releases/download/v${version}/base64-${version}.tbz";
    hash = "sha256-2P7apZvRL+rnrMCLWSjdR4qsUj9MqNJARw0lAGUcZe0=";
  };

  nativeBuildInputs = [ findlib ];

  # otherwise fmt breaks evaluation
  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest bos rresult ];

  meta = {
    homepage = "https://github.com/mirage/ocaml-base64";
    description = "Base64 encoding and decoding in OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
