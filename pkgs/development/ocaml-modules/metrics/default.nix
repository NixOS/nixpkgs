{ lib, fetchurl, buildDunePackage, alcotest, fmt }:

buildDunePackage rec {
  pname = "metrics";
  version = "0.1.0";

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/metrics/releases/download/${version}/metrics-${version}.tbz";
    sha256 = "0jy88anrx3rh19046rrbrjmx922zvz3wlqkk8asilqv9pbvpnp1a";
  };

  propagatedBuildInputs = [ fmt ];

  checkInputs = lib.optional doCheck alcotest;

  doCheck = true;

  meta = {
    description = "Metrics infrastructure for OCaml";
    homepage = "https://github.com/mirage/metrics";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
