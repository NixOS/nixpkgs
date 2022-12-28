{ lib, fetchurl, buildDunePackage, ocaml, alcotest, bos, rresult }:

buildDunePackage rec {
  pname = "base64";
  version = "3.5.0";

  minimumOCamlVersion = "4.03";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-base64/releases/download/v${version}/base64-v${version}.tbz";
    sha256 = "sha256-WJ3pwAV46/54QZismBjTWGxHSyMWts0+HEbMsfYq46Q=";
  };

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
