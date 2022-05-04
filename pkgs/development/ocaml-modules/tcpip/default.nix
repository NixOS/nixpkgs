{ lib, buildDunePackage, fetchurl
, bisect_ppx, ppx_cstruct, pkg-config
, rresult, cstruct, cstruct-lwt, mirage-net, mirage-clock
, mirage-random, mirage-stack, mirage-protocols, mirage-time
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
  version = "7.1.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "sha256-4nd2OVZa4w22I4bgglnS8lrNfjTk40PL5n6Oh6n+osw=";
  };

  nativeBuildInputs = [
    bisect_ppx
    ppx_cstruct
    pkg-config
  ];

  propagatedBuildInputs = [
    rresult
    cstruct
    cstruct-lwt
    mirage-net
    mirage-clock
    mirage-random
    mirage-random-test
    mirage-stack
    mirage-protocols
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
  ] ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  doCheck = false;
  checkInputs = [
    alcotest
    mirage-flow
    mirage-vnetif
    pcap-format
    mirage-clock-unix
    ipaddr-cstruct
  ];

  meta = with lib; {
    description = "OCaml TCP/IP networking stack, used in MirageOS";
    homepage = "https://github.com/mirage/mirage-tcpip";
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
