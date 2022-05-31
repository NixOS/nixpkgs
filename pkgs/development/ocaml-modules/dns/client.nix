{ lib, buildDunePackage, dns, lwt, cstruct, fmt, logs, randomconv
, domain-name, ipaddr, tcpip, mirage-random, mirage-time, mirage-clock
, mtime, mirage-crypto-rng, happy-eyeballs, alcotest, tls, tls-mirage
, x509, ca-certs, ca-certs-nss
}:

buildDunePackage {
  pname = "dns-client";
  inherit (dns) src version;

  useDune2 = true;

  propagatedBuildInputs = [
    dns
    lwt
    cstruct
    fmt
    logs
    randomconv
    domain-name
    ipaddr
    tcpip
    mirage-random
    mirage-time
    mirage-clock
    mtime
    mirage-crypto-rng
    happy-eyeballs
    tls
    tls-mirage
    x509
    ca-certs
    ca-certs-nss
  ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = dns.meta // {
    description = "Pure DNS resolver API";
    mainProgram = "dns-client.unix";
  };
}
