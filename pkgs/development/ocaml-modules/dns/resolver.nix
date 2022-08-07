{ buildDunePackage, dns, dns-server, dns-mirage, lru, duration
, randomconv, lwt, mirage-time, mirage-clock, mirage-random
, tcpip, tls, tls-mirage
, alcotest
}:

buildDunePackage {
  pname = "dns-resolver";

  inherit (dns) version src;

  propagatedBuildInputs = [
    dns
    dns-server
    dns-mirage
    lru
    duration
    randomconv
    lwt
    mirage-time
    mirage-clock
    mirage-random
    tcpip
    tls
    tls-mirage
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = dns.meta // {
    description = "DNS resolver business logic";
  };
}
