{ lib, fetchurl, buildDunePackage
, cstruct, fmt, lwt, mirage-device, mirage-kv
}:

buildDunePackage rec {
  pname = "mirage-fs";
  version = "3.0.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-fs/releases/download/v${version}/mirage-fs-v${version}.tbz";
    sha256 = "0px18bgk528vr7iw78r0j3z4sdcz684sfcj47ibbly2adbvd64yk";
  };

  propagatedBuildInputs = [ cstruct fmt lwt mirage-device mirage-kv ];

  meta = {
    description = "MirageOS signatures for filesystem devices";
    homepage = "https://github.com/mirage/mirage-fs";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
