{ lib, buildDunePackage, cstruct, dns
, mirage-crypto, mirage-crypto-pk, mirage-crypto-ec
, domain-name, logs, base64, alcotest
}:

buildDunePackage {
  pname = "dnssec";
  inherit (dns) src version;

  propagatedBuildInputs = [
    cstruct
    dns
    mirage-crypto
    mirage-crypto-pk
    mirage-crypto-ec
    domain-name
    logs
  ];
  checkInputs = [ alcotest base64 ];
  doCheck = false; # broken output diff

  meta = dns.meta // {
    description = "DNSSec support for OCaml-DNS";
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
