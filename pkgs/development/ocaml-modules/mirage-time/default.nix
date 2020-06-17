{ lib, buildDunePackage, fetchurl, ocaml_lwt }:

buildDunePackage rec {
  minimumOCamlVersion = "4.06";

  pname = "mirage-time";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-time/releases/download/v${version}/mirage-time-v${version}.tbz";
    sha256 = "1w6mm4g7fc19cs0ncs0s9fsnb1k1s04qqzs9bsqvq8ngsb90cbh0";
  };

  propagatedBuildInputs = [ ocaml_lwt ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-time";
    description = "Time operations for MirageOS";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
