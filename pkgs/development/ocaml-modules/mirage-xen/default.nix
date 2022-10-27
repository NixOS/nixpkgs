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
  version = "7.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-xen/releases/download/v${version}/mirage-xen-${version}.tbz";
    sha256 = "sha256-5ZdzourQshHGtYPPdJtJLpH8P6ZLNbjQWy7TDxcY3OA=";
  };

  minimalOCamlVersion = "4.08";

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
