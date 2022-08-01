{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "mirage-clock";
  version = "4.2.0";

  useDune2 = true;

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-clock/releases/download/v${version}/mirage-clock-${version}.tbz";
    sha256 = "0iwqi2381fbi3jlcw424dbhjs4fpisw7qpqzfjx7jg72bdfx25zs";
  };

  meta = {
    description = "Libraries and module types for portable clocks";
    homepage = "https://github.com/mirage/mirage-clock";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}


