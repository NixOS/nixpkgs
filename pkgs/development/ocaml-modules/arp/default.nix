{ lib
, stdenv
, buildDunePackage
, fetchurl
, cstruct
, duration
, ethernet
, ipaddr
, logs
, lwt
, macaddr
, mirage-time
, alcotest
, mirage-clock-unix
, mirage-flow
, mirage-random
, mirage-random-test
, mirage-time-unix
, mirage-vnetif
, bisect_ppx
}:

buildDunePackage rec {
  pname = "arp";
  version = "3.1.1";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-6jPFiene6jAPtivCugtVfP3+6k9A5gBoWzpoxoaPBvE=";
  };

  minimalOCamlVersion = "4.08";

  nativeBuildInputs = [
    bisect_ppx
  ];

  propagatedBuildInputs = [
    cstruct
    duration
    ethernet
    ipaddr
    logs
    lwt
    macaddr
    mirage-time
  ];

  ## NOTE: As of 18 april 2023 and ARP version 3.0.0, tests fail on Darwin.
  doCheck = ! stdenv.isDarwin;
  checkInputs = [
    alcotest
    mirage-clock-unix
    mirage-flow
    mirage-random
    mirage-random-test
    mirage-time-unix
    mirage-vnetif
  ];

  meta = with lib; {
    description = "Address Resolution Protocol purely in OCaml";
    homepage = "https://github.com/mirage/arp";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
