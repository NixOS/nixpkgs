{ lib, buildDunePackage, fetchurl, alcotest}:

buildDunePackage rec {
  pname = "backoff";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/backoff/releases/download/${version}/backoff-${version}.tbz";
    hash = "sha256-EaSseCKekNE03gaNiqh5Y11r8TF9XulR9AZboPWMIwA=";
  };

  doCheck = true;

  checkInputs = [ alcotest ];

  meta = {
    description = "Exponential backoff mechanism for OCaml";
    homepage = "https://github.com/ocaml-multicore/backoff";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

  minimalOCamlVersion = "4.13";
}
