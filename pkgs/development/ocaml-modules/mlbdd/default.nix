{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ounit,
}:

buildDunePackage {
  pname = "mlbdd";
  version = "0.7.3";

  minimalOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "arlencox";
    repo = "mlbdd";
    rev = "v0.7.3";
    hash = "sha256-TUdgx+B5341VJsnP7iTHID7hNC+5G/I2xNM5F3mdb/A=";
  };

  checkInputs = [ ounit ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/arlencox/mlbdd";
    description = "A not-quite-so-simple Binary Decision Diagrams implementation for OCaml";
    maintainers = with lib.maintainers; [ katrinafyi ];
  };
}
