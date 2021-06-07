{ lib, fetchurl, buildDunePackage, alcotest, fmt }:

buildDunePackage rec {
  pname = "metrics";
  version = "0.2.0";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/metrics/releases/download/${version}/metrics-${version}.tbz";
    sha256 = "0j215cji3n78lghzi9m6kgr3r1s91v681hfnn7cgybb31d7gjkqg";
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
