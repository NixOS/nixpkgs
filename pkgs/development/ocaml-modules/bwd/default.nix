{ lib, fetchFromGitHub, buildDunePackage, qcheck-core }:

buildDunePackage rec {
  pname = "bwd";
  version = "2.1.0";

  minimalOCamlVersion = "4.12";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = "ocaml-bwd";
    rev = version;
    hash = "sha256-ucXOBjD1behL2h8CZv64xtRjCPkajZic7G1oxxDmEXY=";
  };

  doCheck = true;
  checkInputs = [ qcheck-core ];

  meta = {
    description = "Backward Lists";
    inherit (src.meta) homepage;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
