{ buildDunePackage
, cstruct
, dns
, mirage-crypto
, mirage-crypto-pk
, mirage-crypto-ec
, domain-name
, logs
, alcotest
, base64
}:

buildDunePackage {
  pname = "dnssec";

  inherit (dns) version src;
  duneVersion = "3";

  propagatedBuildInputs = [
    cstruct
    dns
    mirage-crypto
    mirage-crypto-pk
    mirage-crypto-ec
    domain-name
    logs
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    base64
  ];

  meta = dns.meta // {
    description = "DNSSec support for OCaml-DNS";
  };
}
