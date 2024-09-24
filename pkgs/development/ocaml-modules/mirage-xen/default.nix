{ lib
, buildDunePackage
, fetchurl
, cstruct
, lwt
, shared-memory-ring-lwt
, xenstore
, lwt-dllist
, mirage-profile
, mirage-runtime
, logs
, fmt
, bheap
, duration
, io-page
}:

buildDunePackage rec {
  pname = "mirage-xen";
  version = "8.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-xen/releases/download/v${version}/mirage-xen-${version}.tbz";
    hash = "sha256-x8i2Kbz0EcifZK/lbDIFa9Kwtl1/xzbYV9h9E+EtGP4=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    cstruct
    lwt
    shared-memory-ring-lwt
    xenstore
    lwt-dllist
    mirage-profile
    mirage-runtime
    io-page
    logs
    fmt
    bheap
    duration
  ];

  meta = with lib; {
    description = "Xen core platform libraries for MirageOS";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/mirage-xen";
  };
}
