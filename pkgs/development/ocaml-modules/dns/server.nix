{
  buildDunePackage,
  dns,
  dns-mirage,
  randomconv,
  duration,
  lwt,
  mirage-sleep,
  mirage-mtime,
  mirage-ptime,
  metrics,
  alcotest,
  mirage-crypto-rng,
  dns-tsig,
  base64,
}:

buildDunePackage {
  pname = "dns-server";

  inherit (dns) version src;

  propagatedBuildInputs = [
    dns
    dns-mirage
    randomconv
    duration
    lwt
    mirage-sleep
    mirage-mtime
    mirage-ptime
    metrics
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-crypto-rng
    dns-tsig
    base64
  ];

  meta = dns.meta // {
    description = "DNS server, primary and secondary";
  };
}
