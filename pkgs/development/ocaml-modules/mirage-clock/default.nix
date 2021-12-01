{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "mirage-clock";
  version = "3.1.0";

  useDune2 = true;

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-clock/releases/download/v${version}/mirage-clock-v${version}.tbz";
    sha256 = "0cqa07aqkamw0dvis1fl46brvk81zvb92iy5076ik62gv9n5a0mn";
  };

  meta = {
    description = "Libraries and module types for portable clocks";
    homepage = "https://github.com/mirage/mirage-clock";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}


