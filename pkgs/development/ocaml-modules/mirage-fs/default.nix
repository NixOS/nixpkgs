{ lib, fetchurl, buildDunePackage
, cstruct, fmt, lwt, mirage-kv
}:

buildDunePackage rec {
  pname = "mirage-fs";
  version = "4.0.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-fs/releases/download/v${version}/mirage-fs-v${version}.tbz";
    hash = "sha256-PYZ2HCPuxOv4FU7EHymsa1oIZU7q8TSzzRvlngYdZ3s=";
  };

  propagatedBuildInputs = [ cstruct fmt lwt mirage-kv ];

  meta = {
    description = "MirageOS signatures for filesystem devices";
    homepage = "https://github.com/mirage/mirage-fs";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
