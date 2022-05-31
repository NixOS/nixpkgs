{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "mirage-clock";
  version = "4.2.0";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-clock/releases/download/v${version}/mirage-clock-${version}.tbz";
    sha256 = "sha256-+hfRXVviPHm6dB9ffLiO1xEt4WpEEM6oHHG5gIaImEc=";
  };

  meta = {
    description = "Libraries and module types for portable clocks";
    homepage = "https://github.com/mirage/mirage-clock";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}


