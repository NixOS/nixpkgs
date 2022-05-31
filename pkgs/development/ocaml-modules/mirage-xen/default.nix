{ lib
, buildDunePackage
, fetchurl
, pkg-config
, cstruct
, lwt
, shared-memory-ring-lwt
, xenstore
, lwt-dllist
, mirage-profile
, mirage-runtime
, logs
, fmt
, ocaml-freestanding
, bheap
, duration
, io-page
}:

buildDunePackage rec {
  pname = "mirage-xen";
  version = "7.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-xen/releases/download/v${version}/mirage-xen-${version}.tbz";
    sha256 = "sha256-zNEZSVM7e7y+XzXozdGJBx6aRi1M/E7kbMeJGzL2iI8=";
  };

  minimumOCamlVersion = "4.08";

  nativeBuildInputs = [
    pkg-config
  ];

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
    (ocaml-freestanding.override { target = "xen"; })
  ];

  meta = with lib; {
    description = "Xen core platform libraries for MirageOS";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/mirage-xen";
  };
}
