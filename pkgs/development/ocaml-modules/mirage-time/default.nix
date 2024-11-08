{ lib, buildDunePackage, fetchurl, lwt }:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";

  pname = "mirage-time";
  version = "3.0.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-time/releases/download/v${version}/mirage-time-v${version}.tbz";
    hash = "sha256-DUCUm1jix+i3YszIzgZjRQRiM8jJXQ49F6JC/yicvXw=";
  };

  propagatedBuildInputs = [ lwt ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-time";
    description = "Time operations for MirageOS";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
