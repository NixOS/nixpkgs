{ lib, buildDunePackage, fetchurl
, ppx_cstruct, pkg-config
, cstruct, cstruct-lwt, mirage-net, mirage-clock
, mirage-random, mirage-time
, ipaddr, macaddr, macaddr-cstruct, mirage-profile, fmt
, lwt, lwt-dllist, logs, duration, randomconv, ethernet
, alcotest, mirage-flow, mirage-vnetif, pcap-format
, mirage-clock-unix, arp, ipaddr-cstruct, mirage-random-test
, lru, metrics
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  pname = "tcpip";
  version = "7.1.2";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-lraur6NfFD9yddG+y21jlHKt82gLgYBBbedltlgcRm0=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    ppx_cstruct
    cstruct
    cstruct-lwt
    mirage-net
    mirage-clock
    mirage-random
    mirage-time
    ipaddr
    macaddr
    macaddr-cstruct
    mirage-profile
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
  ] ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-random-test
    mirage-flow
    mirage-vnetif
    pcap-format
    mirage-clock-unix
    ipaddr-cstruct
  ];
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "OCaml TCP/IP networking stack, used in MirageOS";
    homepage = "https://github.com/mirage/mirage-tcpip";
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
