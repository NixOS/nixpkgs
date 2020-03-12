{ lib, buildDunePackage, fetchurl, seq }:

buildDunePackage rec {
  minimumOCamlVersion = "4.03";
  pname = "psq";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/pqwy/psq/releases/download/v${version}/psq-v${version}.tbz";
    sha256 = "1j4lqkq17rskhgcrpgr4n1m1a2b1x35mlxj6f9g05rhpmgvgvknk";
  };

  propagatedBuildInputs = [ seq ];

  meta = {
    description = "Functional Priority Search Queues for OCaml";
    homepage = "https://github.com/pqwy/psq";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.isc;
  };
}
