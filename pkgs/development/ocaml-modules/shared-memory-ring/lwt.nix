{
  lib,
  buildDunePackage,
  shared-memory-ring,
  ppx_cstruct,
  cstruct,
  lwt,
  lwt-dllist,
  mirage-profile,
  ounit,
}:

buildDunePackage {
  pname = "shared-memory-ring-lwt";

  inherit (shared-memory-ring) version src;

  duneVersion = "3";

  buildInputs = [
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    shared-memory-ring
    cstruct
    lwt
    lwt-dllist
    mirage-profile
  ];

  doCheck = true;
  checkInputs = [
    ounit
  ];

  meta = shared-memory-ring.meta // {
    description = "Shared memory rings for RPC and bytestream communications using Lwt";
  };
}
