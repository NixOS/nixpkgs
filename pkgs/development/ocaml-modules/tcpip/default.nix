{
  lib,
  buildDunePackage,
  fetchurl,
  pkg-config,
  cstruct,
  cstruct-lwt,
  mirage-net,
  mirage-clock,
  mirage-random,
  mirage-time,
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
  mirage-clock-unix,
  arp,
  ipaddr-cstruct,
  mirage-random-test,
  lru,
  metrics,
  withFreestanding ? false,
  ocaml-freestanding,
}:

buildDunePackage rec {
  pname = "tcpip";
  version = "8.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-NrTBVr4WcCukxteBotqLoUYrIjcNFVcOERYFbL8CUjM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs =
    [
      cstruct
      cstruct-lwt
      mirage-net
      mirage-clock
      mirage-random
      mirage-time
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
    mirage-random-test
    mirage-flow
    mirage-vnetif
    pcap-format
    mirage-clock-unix
  ];
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "OCaml TCP/IP networking stack, used in MirageOS";
    homepage = "https://github.com/mirage/mirage-tcpip";
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.isc;
  };
}
