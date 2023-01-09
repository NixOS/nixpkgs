{ buildDunePackage, dns, dns-mirage, randomconv, duration, lwt
, mirage-time, mirage-clock, metrics
, alcotest, mirage-crypto-rng, dns-tsig, base64
}:

buildDunePackage {
  pname = "dns-server";

  inherit (dns) version src;
  duneVersion = "3";

  propagatedBuildInputs = [
    dns
    dns-mirage
    randomconv
    duration
    lwt
    mirage-time
    mirage-clock
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
