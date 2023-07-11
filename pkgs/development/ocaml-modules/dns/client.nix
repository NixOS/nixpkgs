{ lib, buildDunePackage, dns, lwt, mirage-clock, mirage-time
, mirage-random, mirage-crypto-rng, mtime, randomconv
, cstruct, fmt, logs, rresult, domain-name, ipaddr, alcotest
, ca-certs, ca-certs-nss
, happy-eyeballs
, tcpip
, tls, tls-mirage
}:

buildDunePackage {
  pname = "dns-client";
  inherit (dns) src version;
  duneVersion = "3";

  propagatedBuildInputs = [
    dns
    randomconv
    domain-name
    mtime
    mirage-crypto-rng
  ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = dns.meta // {
    description = "Pure DNS resolver API";
    mainProgram = "dns-client.unix";
  };
}
