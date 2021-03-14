{ lib, buildDunePackage, fetchurl
, bisect_ppx, ppx_cstruct
, rresult, cstruct, cstruct-lwt, mirage-net, mirage-clock
, mirage-random, mirage-stack, mirage-protocols, mirage-time
, ipaddr, macaddr, macaddr-cstruct, mirage-profile, fmt
, lwt, lwt-dllist, logs, duration, randomconv, ethernet
, alcotest, mirage-flow, mirage-vnetif, pcap-format
, mirage-clock-unix, arp, ipaddr-cstruct, mirage-random-test
, lru
}:

buildDunePackage rec {
  pname = "tcpip";
  version = "6.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0wbrs8jz1vw3zdrqmqcwawxh4yhc2gy30rw7gz4w116cblkvnb8s";
  };

  nativeBuildInputs = [
    bisect_ppx
    ppx_cstruct
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
