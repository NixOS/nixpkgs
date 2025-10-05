{
  lib,
  buildDunePackage,
  fetchurl,
  pkg-config,
  cstruct,
  cstruct-lwt,
  mirage-net,
  mirage-mtime,
  mirage-crypto-rng,
  mirage-sleep,
  macaddr,
  macaddr-cstruct,
  fmt,
  lwt,
  lwt-dllist,
  logs,
  duration,
  randomconv,
  ethernet,
  alcotest,
  mirage-flow,
  mirage-vnetif,
  pcap-format,
  arp,
  ipaddr-cstruct,
  lru,
  metrics,
  withFreestanding ? false,
  ocaml-freestanding,
}:

buildDunePackage rec {
  pname = "tcpip";
  version = "9.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-+sB86YaBHPXj1xNz2StjHMMPvvVI1tohsJFyEtz5CwM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    cstruct
    cstruct-lwt
    mirage-net
    mirage-mtime
    mirage-crypto-rng
    mirage-sleep
    ipaddr-cstruct
    macaddr
    macaddr-cstruct
    fmt
    lwt
    lwt-dllist
    logs
    duration
    randomconv
    ethernet
    lru
    metrics
    arp
    mirage-flow
  ]
  ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-vnetif
    pcap-format
  ];
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "OCaml TCP/IP networking stack, used in MirageOS";
    homepage = "https://github.com/mirage/mirage-tcpip";
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
