{
  lib,
  stdenv,
  buildDunePackage,
  fetchurl,
  cstruct,
  duration,
  ethernet,
  ipaddr,
  logs,
  lru,
  lwt,
  macaddr,
  mirage-sleep,
  alcotest,
  bos,
  mirage-vnetif,
}:

buildDunePackage (finalAttrs: {
  pname = "arp";
  version = "4.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/arp/releases/download/v${finalAttrs.version}/arp-${finalAttrs.version}.tbz";
    hash = "sha256-AvjxveUgSRBNhZQvCp1oa+JfEXSIronECk4nNos8hl0=";
  };

  propagatedBuildInputs = [
    cstruct
    duration
    ethernet
    ipaddr
    logs
    lru
    lwt
    macaddr
    mirage-sleep
  ];

  ## NOTE: As of 18 april 2023 and ARP version 3.0.0, tests fail on Darwin.
  doCheck = !stdenv.hostPlatform.isDarwin;
  checkInputs = [
    alcotest
    bos
    mirage-vnetif
  ];

  meta = {
    description = "Address Resolution Protocol purely in OCaml";
    homepage = "https://github.com/mirage/arp";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
