{ lib, buildDunePackage
, happy-eyeballs
, duration
, dns-client
, domain-name
, ipaddr
, fmt
, logs
, lwt
, mirage-clock
, mirage-random
, mirage-time
, tcpip
}:

buildDunePackage {
  pname = "happy-eyeballs-mirage";

  inherit (happy-eyeballs) src version;

  minimumOCamlVersion = "4.08";

  strictDeps = true;

  propagatedBuildInputs = [
    happy-eyeballs
    duration
    dns-client
    domain-name
    ipaddr
    fmt
    logs
    lwt
    mirage-clock
    mirage-random
    mirage-time
    tcpip
  ];
  doCheck = false;

  meta = happy-eyeballs.meta;
}
