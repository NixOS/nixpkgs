{ lib, fetchurl, buildDunePackage, alcotest, bos, dune-configurator }:

buildDunePackage rec {
  pname = "base64";
  version = "3.4.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-base64/releases/download/v${version}/base64-v${version}.tbz";
    sha256 = "0d0n5gd4nkdsz14jnxq13f1f7rzxmndg5xql039a8wfppmazd70w";
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
