{ lib, buildDunePackage, fetchurl
, cstruct, ipaddr, macaddr, logs, lwt, duration
, mirage-time, mirage-protocols, mirage-profile
, alcotest, ethernet, fmt, mirage-vnetif, mirage-random
, mirage-random-test, mirage-clock-unix, mirage-time-unix
, bisect_ppx
}:

buildDunePackage rec {
  pname = "arp";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "1x3l8v96ywc3wrcwbf0j04b8agap4fif0fz6ki2ndzx57yqcjszn";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

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
    mirage-profile
    mirage-protocols
    mirage-time
  ];

  doCheck = true;
  nativeCheckInputs = [
    alcotest
    mirage-clock-unix
    mirage-profile
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
