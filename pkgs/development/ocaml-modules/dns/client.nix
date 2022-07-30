{ lib, buildDunePackage, dns, lwt, mirage-clock, mirage-time, callPackage
, mirage-random, mirage-crypto-rng, mtime, randomconv, cmdliner_1_1
, cstruct, rresult, domain-name, ipaddr, alcotest, logs, fmt, cmdliner
, ca-certs, ca-certs-nss
, happy-eyeballs
, tcpip
, tls, tls-mirage
}:

buildDunePackage {
  pname = "dns-client";
  inherit (dns) src version;

  propagatedBuildInputs = [ cstruct
                            logs
                            fmt
                            dns
                            randomconv
                            domain-name
                            ipaddr
                            lwt
                            mirage-random
                            mirage-time
                            mirage-clock
                            ca-certs-nss
                            ca-certs
                            happy-eyeballs
                            tcpip
                            tls
                            tls-mirage
                            mtime
                            mirage-crypto-rng ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = dns.meta // {
    description = "Pure DNS resolver API";
    mainProgram = "dns-client.unix";
  };
}
