{ lib, fetchurl, buildDunePackage, cstruct, bigarray-compat }:

buildDunePackage rec {
  minimumOCamlVersion = "4.03";
  pname = "eqaf";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/mirage/eqaf/releases/download/v${version}/eqaf-v${version}.tbz";
    sha256 = "068r231ia87mpqpaqzqb9sjfj6yaqrwvcls2p173aa4qg38xvsq9";
  };

  propagatedBuildInputs = [ cstruct bigarray-compat ];

  meta = {
    description = "Constant time equal function to avoid timing attacks in OCaml";
    homepage = "https://github.com/mirage/eqaf";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
