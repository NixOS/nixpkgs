{
  lib,
  buildDunePackage,
  fetchurl,
  pkg-config,
  cstruct,
  cstruct-lwt,
  mirage-net,
  mirage-clock,
  mirage-crypto-rng-mirage,
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
  mirage-crypto-rng,
  lru,
  metrics,
  withFreestanding ? false,
  ocaml-freestanding,
}:

buildDunePackage rec {
  pname = "tcpip";
  version = "8.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-kW5oirqJdnbERNuBKfSWOtc5+NG+Yx2eAJxiKLS31u0=";
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
      mirage-crypto-rng-mirage
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
    mirage-crypto-rng
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
