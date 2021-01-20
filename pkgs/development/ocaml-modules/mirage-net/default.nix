{ lib, fetchurl, buildDunePackage
, cstruct, fmt, lwt, macaddr, mirage-device
}:

buildDunePackage rec {
  pname = "mirage-net";
  version = "3.0.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-net/releases/download/v${version}/mirage-net-v${version}.tbz";
    sha256 = "0yfvl0fgs7xy5i7kkparaa7a315a2h7kb1z24fmmnwnyaji57dg3";
  };

  propagatedBuildInputs = [ cstruct fmt lwt macaddr mirage-device ];

  meta = {
    description = "Network signatures for MirageOS";
    homepage = "https://github.com/mirage/mirage-net";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
