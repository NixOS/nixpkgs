{ lib, buildDunePackage, fetchurl, cstruct }:

buildDunePackage rec {
  pname = "mirage-random";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-random/releases/download/v${version}/mirage-random-v${version}.tbz";
    sha256 = "0qj41d5smkkkbjwsnz71bhhj94d2cwv53rf3j4rhky0pqbkidnv1";
  };

  propagatedBuildInputs = [ cstruct ];

  meta = {
    description = "Random signatures for MirageOS";
    homepage = "https://github.com/mirage/mirage-random";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
