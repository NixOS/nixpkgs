{ lib, fetchFromGitHub, buildDunePackage, ocaml }:

buildDunePackage {
  pname = "landmarks";
  version = "1.4";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "LexiFi";
    repo = "landmarks";
    rev = "b0c753cd2a4c4aa00dffdd3be187d8ed592fabf7";
    hash = "sha256-Wpr76JURUFrj7v39rdM/2Lr7boa7nL/bnPEz1vMrmQo";
  };

  doCheck = lib.versionAtLeast ocaml.version "4.08"
    && lib.versionOlder ocaml.version "5.0";

  meta = with lib; {
    description = "Simple Profiling Library for OCaml";
    maintainers = [ maintainers.kenran ];
    license = licenses.mit;
  };
}
