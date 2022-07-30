{ lib, buildDunePackage, dns, dns-server, dns-mirage, lru, duration, base64, cstruct
, randomconv, lwt, mirage-crypto, mirage-crypto-pk, mirage-crypto-ec
, tcpip, tls, tls-mirage, domain-name, logs, cmdliner_1_1, cmdliner
, alcotest, callPackage
}:

buildDunePackage {
  pname = "dnssec";

  inherit (dns) version src;

  propagatedBuildInputs = [
    cstruct
    mirage-crypto
    mirage-crypto-pk
    mirage-crypto-ec
    (logs.overrideAttrs (old: {
      buildInputs = [cmdliner_1_1] ++ lib.lists.remove cmdliner old.buildInputs;
    }))
    dns
    domain-name
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    dns
    mirage-crypto-pk
    base64
    logs
  ];

  meta = dns.meta // {
    description = "DNSSec (DNS security extensions) for OCaml-DNS, including signing and verifying of RRSIG records.";
  };
}
