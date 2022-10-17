{ lib, fetchurl, buildDunePackage
, fmt, mirage-device
, alcotest
}:

buildDunePackage rec {
  pname = "mirage-kv";
  version = "3.0.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-kv/releases/download/v${version}/mirage-kv-v${version}.tbz";
    sha256 = "1n736sjvdd8rkbc2b5jm9sn0w6hvhjycma5328r0l03v24vk5cki";
  };

  propagatedBuildInputs = [ fmt mirage-device ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "MirageOS signatures for key/value devices";
    homepage = "https://github.com/mirage/mirage-kv";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
