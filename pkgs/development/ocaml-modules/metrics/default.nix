{ lib, fetchurl, buildDunePackage, alcotest, fmt }:

buildDunePackage rec {
  pname = "metrics";
  version = "0.4.1";

  minimalOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/metrics/releases/download/v${version}/metrics-${version}.tbz";
    sha256 = "sha256-d+DCD7XB0GED27DsC8YEW+48YcAK0EI8l4Uqx/PGFE0=";
  };

  propagatedBuildInputs = [ fmt ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = {
    description = "Metrics infrastructure for OCaml";
    homepage = "https://github.com/mirage/metrics";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
