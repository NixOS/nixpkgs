{ buildDunePackage, dns, dns-mirage, randomconv, duration, lwt
, mirage-time, mirage-clock, mirage-stack, metrics
, alcotest, mirage-crypto-rng, dns-tsig, base64
}:

buildDunePackage {
  pname = "dns-server";

  inherit (dns) version src useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [
    dns
    dns-mirage
    randomconv
    duration
    lwt
    mirage-time
    mirage-clock
    mirage-stack
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
