{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
}:

buildDunePackage rec {
  pname = "ohex";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/ocaml/opam-source-archives/raw/main/ohex-${version}.tar.gz";
    hash = "sha256-prV7rbo0sAx3S2t4YtjniJEVq43uLXK8ZMsqoMzn2Ow=";
  };

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Hexadecimal encoding and decoding";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
