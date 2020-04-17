{ lib, buildDunePackage, fetchurl, duration, ipaddr, mirage-device, mirage-flow }:

buildDunePackage rec {
  pname = "mirage-protocols";
  version = "4.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-protocols/releases/download/v${version}/mirage-protocols-v${version}.tbz";
    sha256 = "188m8x6xdw1bllwrpa8f8bqbdqy20kjfk7q8p8jf8j0daf7kl3mi";
  };

  propagatedBuildInputs = [ duration ipaddr mirage-device mirage-flow ];

  meta = {
    description = "MirageOS signatures for network protocols";
    homepage = "https://github.com/mirage/mirage-protocols";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}


