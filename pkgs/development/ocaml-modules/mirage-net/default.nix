{
  lib,
  fetchurl,
  buildDunePackage,
  cstruct,
  fmt,
  lwt,
  macaddr,
  mirage-device,
}:

buildDunePackage rec {
  pname = "mirage-net";
  version = "4.0.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-net/releases/download/v${version}/mirage-net-v${version}.tbz";
    hash = "sha256-Zo7/0Ye4GgqzJFCHDBXbuJ/5ETl/8ziolRgH4lDhlM4=";
  };

  propagatedBuildInputs = [
    cstruct
    fmt
    lwt
    macaddr
    mirage-device
  ];

  meta = {
    description = "Network signatures for MirageOS";
    homepage = "https://github.com/mirage/mirage-net";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
