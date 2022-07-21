{ lib, buildDunePackage, dns, lwt, mirage-clock, mirage-time, callPackage
, mirage-random, mirage-crypto-rng, mtime, randomconv
, cstruct, rresult, domain-name, ipaddr, alcotest
, ca-certs, ca-certs-nss
, happy-eyeballs
, tcpip
, tls, tls-mirage
}:

buildDunePackage {
  pname = "dns-client";
  inherit (dns) src version;

  propagatedBuildInputs = [ cstruct (callPackage ./fmt.nix { } ) (callPackage
                            ./logs.nix {}) dns randomconv domain-name ipaddr lwt
                            mirage-random mirage-time mirage-clock ca-certs
                            ca-certs-nss happy-eyeballs tcpip tls tls-mirage
                            mtime mirage-crypto-rng ]; checkInputs = [ alcotest
                            ]; doCheck = true;

  meta = dns.meta // {
    description = "Pure DNS resolver API";
    mainProgram = "dns-client.unix";
  };
}
