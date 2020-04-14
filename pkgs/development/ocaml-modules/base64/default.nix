{ lib, fetchpatch, fetchzip, buildDunePackage, alcotest, bos }:

let version = "3.2.0"; in

buildDunePackage rec {
  pname = "base64";
  inherit version;

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-base64/archive/v${version}.tar.gz";
    sha256 = "1ilw3zj0w6cq7i4pvr8m2kv5l5f2y9aldmv72drlwwns013b1gwy";
  };

  minimumOCamlVersion = "4.03";

  buildInputs = [ bos ];

  # Fix test-suite for alcotest ≥ 1.0
  patches = [(fetchpatch {
    url = "https://github.com/mirage/ocaml-base64/commit/8d334d02aa52875158fae3e2fb8fe0a5596598d0.patch";
    sha256 = "0lvqdp98qavpzis1wgwh3ijajq79hq47898gsrk37fpyjbrdzf5q";
  })];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/mirage/ocaml-base64";
    description = "Base64 encoding and decoding in OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
