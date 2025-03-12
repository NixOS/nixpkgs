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
  mirage-crypto-rng-mirage,
  tcpip,
  metrics,
}:

buildDunePackage {
  pname = "dns-stub";

  inherit (dns) version src;

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
    mirage-crypto-rng-mirage
    tcpip
    metrics
  ];

  doCheck = true;

  meta = dns.meta // {
    description = "DNS stub resolver";
  };
}
