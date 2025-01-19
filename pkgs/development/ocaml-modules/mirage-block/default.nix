{
  lib,
  fetchurl,
  buildDunePackage,
  cstruct,
  lwt,
  fmt,
}:

buildDunePackage rec {
  pname = "mirage-block";
  version = "3.0.2";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-block/releases/download/v${version}/mirage-block-${version}.tbz";
    hash = "sha256-UALUfeL0G1mfSsLgAb/HpQ6OV12YtY+GUOYG6yhUwAI=";
  };

  propagatedBuildInputs = [
    cstruct
    lwt
    fmt
  ];

  meta = with lib; {
    description = "Block signatures and implementations for MirageOS";
    homepage = "https://github.com/mirage/mirage-block";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
