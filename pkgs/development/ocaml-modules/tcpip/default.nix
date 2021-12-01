{ lib, buildDunePackage, fetchurl
, bisect_ppx, ppx_cstruct, pkg-config
, rresult, cstruct, cstruct-lwt, mirage-net, mirage-clock
, mirage-random, mirage-stack, mirage-protocols, mirage-time
, ipaddr, macaddr, macaddr-cstruct, mirage-profile, fmt
, lwt, lwt-dllist, logs, duration, randomconv, ethernet
, alcotest, mirage-flow, mirage-vnetif, pcap-format
, mirage-clock-unix, arp, ipaddr-cstruct, mirage-random-test
, lru
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  pname = "tcpip";
  version = "6.2.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "d0f6e643ce04da808d5f977c5ab2422cdb4f67e7abdc46dd6776ceada7151e1b";
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
  ] ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-flow
    mirage-vnetif
    pcap-format
    mirage-clock-unix
    arp
    ipaddr-cstruct
  ];

  meta = with lib; {
    description = "OCaml TCP/IP networking stack, used in MirageOS";
    homepage = "https://github.com/mirage/mirage-tcpip";
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
