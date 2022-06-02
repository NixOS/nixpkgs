{ lib, buildDunePackage, fetchurl, ocaml_lwt }:

buildDunePackage rec {
  minimumOCamlVersion = "4.06";

  pname = "mirage-time";
  version = "3.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-time/releases/download/v${version}/mirage-time-v${version}.tbz";
    sha256 = "sha256-DUCUm1jix+i3YszIzgZjRQRiM8jJXQ49F6JC/yicvXw=";
  };

  propagatedBuildInputs = [ ocaml_lwt ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-time";
    description = "Time operations for MirageOS";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
