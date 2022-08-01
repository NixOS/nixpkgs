{ lib, buildDunePackage, happy-eyeballs, duration, dns-client, domain-name
, ipaddr, fmt, logs, lwt, mirage-clock, tcpip, mirage-random, mirage-time}:


buildDunePackage rec {
  pname = "happy-eyeballs-mirage";

  minimalOCamlVersion = "4.08";
  inherit (happy-eyeballs) version src ;

  useDune2 = true;

  propagatedBuildInputs = [
    happy-eyeballs
    domain-name
    duration
    fmt
    ipaddr
    logs
    dns-client
    mirage-clock
    mirage-random
    mirage-time
    tcpip
    lwt
  ];


  meta = {
    description = "Connecting to a remote host via IP version 4 or 6 using Mirage";
    homepage = "https://github.com/roburio/happy-eyeballs";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
