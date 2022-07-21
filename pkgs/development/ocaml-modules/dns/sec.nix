{ buildDunePackage, dns, dns-server, dns-mirage, lru, duration, base64, cstruct
, randomconv, lwt, mirage-crypto, mirage-crypto-pk, mirage-crypto-ec
, tcpip, tls, tls-mirage, domain-name
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
    (callPackage ./logs.nix {} )
    dns
    domain-name
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    dns
    mirage-crypto-pk
    base64
    (callPackage ./logs.nix {} )
  ];

  meta = dns.meta // {
    description = "DNSSec (DNS security extensions) for OCaml-DNS, including signing and verifying of RRSIG records.";
  };
}
