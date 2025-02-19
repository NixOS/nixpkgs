{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
}:

buildDunePackage rec {
  pname = "backoff";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/backoff/releases/download/${version}/backoff-${version}.tbz";
    hash = "sha256-AL6jEbInsbwKVYedpNzjix/YRHtOTizxk6aVNzesnwM=";
  };

  doCheck = true;

  checkInputs = [ alcotest ];

  meta = {
    description = "Exponential backoff mechanism for OCaml";
    homepage = "https://github.com/ocaml-multicore/backoff";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

  minimalOCamlVersion = "4.12";
}
