{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "mirage-clock";
  version = "3.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-clock/releases/download/v${version}/mirage-clock-v${version}.tbz";
    sha256 = "12m2dph69r843clrbcgfjj2gcxmq2kdb7g5d91kfj16g13b0vsa3";
  };

  meta = {
    description = "Libraries and module types for portable clocks";
    homepage = "https://github.com/mirage/mirage-clock";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}


