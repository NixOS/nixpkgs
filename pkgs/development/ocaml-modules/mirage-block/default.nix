{ lib, fetchurl, buildDunePackage
, cstruct, lwt, mirage-device
}:

buildDunePackage rec {
  pname = "mirage-block";
  version = "2.0.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-block/releases/download/v${version}/mirage-block-v${version}.tbz";
    sha256 = "1wp8wmixaz9i2sbvq6nkx903lbnpdgb2w404pz1wk8kcg9p3ilcc";
  };

  propagatedBuildInputs = [ cstruct lwt mirage-device ];

  meta = with lib; {
    description = "Block signatures and implementations for MirageOS";
    homepage = "https://github.com/mirage/mirage-block";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
