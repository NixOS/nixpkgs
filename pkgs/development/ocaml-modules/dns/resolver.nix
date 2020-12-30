{ buildDunePackage, dns, dns-server, dns-mirage, lru, duration
, randomconv, lwt, mirage-time, mirage-clock, mirage-random
, alcotest
}:

buildDunePackage {
  pname = "dns-resolver";

  inherit (dns) version src useDune2 minimumOCamlVersion;

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
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = dns.meta // {
    description = "DNS resolver business logic";
  };
}
