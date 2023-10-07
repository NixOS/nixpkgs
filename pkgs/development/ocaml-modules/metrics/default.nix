{ lib, fetchurl, buildDunePackage, alcotest, fmt }:

buildDunePackage rec {
  pname = "metrics";
  version = "0.4.0";

  minimalOCamlVersion = "4.04";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/metrics/releases/download/v${version}/metrics-${version}.tbz";
    sha256 = "sha256-kbh1WktQkDcXE8O1WRm+vtagVfSql8S5gr0bXn/jia8=";
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
