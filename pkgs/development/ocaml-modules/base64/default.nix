{ lib, fetchzip, buildDunePackage, alcotest, bos }:

let version = "3.2.0"; in

buildDunePackage {
  pname = "base64";
  inherit version;

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-base64/archive/v${version}.tar.gz";
    sha256 = "1ilw3zj0w6cq7i4pvr8m2kv5l5f2y9aldmv72drlwwns013b1gwy";
  };

  minimumOCamlVersion = "4.03";

  buildInputs = [ alcotest bos ];

  doCheck = true;

  meta = {
    homepage = https://github.com/mirage/ocaml-base64;
    description = "Base64 encoding and decoding in OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
