{ lib, fetchurl, buildDunePackage, alcotest, bos, dune-configurator }:

buildDunePackage rec {
  pname = "base64";
  version = "3.5.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-base64/releases/download/v${version}/base64-v${version}.tbz";
    sha256 = "sha256-WJ3pwAV46/54QZismBjTWGxHSyMWts0+HEbMsfYq46Q=";
  };

  buildInputs = [ bos dune-configurator ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/mirage/ocaml-base64";
    description = "Base64 encoding and decoding in OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
