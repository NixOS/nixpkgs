{ lib, buildDunePackage, fetchurl, cstruct }:

buildDunePackage rec {
  pname = "mirage-random";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-random/releases/download/v${version}/mirage-random-v${version}.tbz";
    sha256 = "sha256-Sf4/KB1kMMwXI+yr5H/JuOmynYPNXwlk9dAA+gFAZs8=";
  };

  propagatedBuildInputs = [ cstruct ];

  meta = {
    description = "Random signatures for MirageOS";
    homepage = "https://github.com/mirage/mirage-random";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
