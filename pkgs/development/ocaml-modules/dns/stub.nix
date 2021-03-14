{ buildDunePackage, dns, dns-client, dns-mirage, dns-resolver, dns-tsig
, dns-server, duration, randomconv, lwt, mirage-time, mirage-clock
, mirage-random, mirage-stack, metrics
}:

buildDunePackage {
  pname = "dns-stub";

  inherit (dns) version src useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [
    dns
    dns-client
    dns-mirage
    dns-resolver
    dns-tsig
    dns-server
    duration
    randomconv
    lwt
    mirage-time
    mirage-clock
    mirage-random
    mirage-stack
    metrics
  ];

  doCheck = true;

  meta = dns.meta // {
    description = "DNS stub resolver";
  };
}
