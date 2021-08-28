{ buildDunePackage, dns, mirage-crypto, base64, alcotest }:

buildDunePackage {
  pname = "dns-tsig";

  inherit (dns) version src useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [
    mirage-crypto
    dns
    base64
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = dns.meta // {
    description = "TSIG support for DNS";
  };
}
