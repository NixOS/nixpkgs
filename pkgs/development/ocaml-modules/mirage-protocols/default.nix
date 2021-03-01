{ lib, buildDunePackage, fetchurl, duration, ipaddr, mirage-device, mirage-flow }:

buildDunePackage rec {
  pname = "mirage-protocols";
  version = "5.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-protocols/releases/download/v${version}/mirage-protocols-v${version}.tbz";
    sha256 = "1bd6zgxhq2qliyzzarfvaj3ksr20ryghxq6h24i2hha7rwim63bk";
  };

  propagatedBuildInputs = [ duration ipaddr mirage-device mirage-flow ];

  meta = {
    description = "MirageOS signatures for network protocols";
    homepage = "https://github.com/mirage/mirage-protocols";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}


