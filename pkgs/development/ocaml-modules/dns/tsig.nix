{
  buildDunePackage,
  dns,
  digestif,
  base64,
  alcotest,
}:

buildDunePackage {
  pname = "dns-tsig";

  inherit (dns) version src;

  propagatedBuildInputs = [
    digestif
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
