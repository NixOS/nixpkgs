{
  buildDunePackage,
  dns,
  dns-client-mirage,
  dns-mirage,
  dns-resolver,
  dns-tsig,
  dns-server,
  duration,
  randomconv,
  lwt,
  mirage-time,
  mirage-clock,
  mirage-random,
  tcpip,
  metrics,
}:

buildDunePackage {
  pname = "dns-stub";

  inherit (dns) version src;
  duneVersion = "3";

  propagatedBuildInputs = [
    dns
    dns-client-mirage
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
    tcpip
    metrics
  ];

  doCheck = true;

  meta = dns.meta // {
    description = "DNS stub resolver";
  };
}
