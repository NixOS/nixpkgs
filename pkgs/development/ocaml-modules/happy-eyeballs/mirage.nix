{ buildDunePackage
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

  minimalOCamlVersion = "4.08";

  strictDeps = true;

  buildInputs = [
    duration
    ipaddr
    domain-name
    fmt
    mirage-clock
    mirage-random
    mirage-time
  ];

  propagatedBuildInputs = [
    dns-client
    happy-eyeballs
    logs
    lwt
    tcpip
  ];

  doCheck = true;

  meta = happy-eyeballs.meta // {
    description = "Connecting to a remote host via IP version 4 or 6 using Mirage";
  };
}
