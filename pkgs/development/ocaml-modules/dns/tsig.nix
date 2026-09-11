{
  buildDunePackage,
  dns,
  digestif,
  base64,
  eqaf,
  alcotest,
}:

buildDunePackage {
  pname = "dns-tsig";

  inherit (dns) version src;

  propagatedBuildInputs = [
    digestif
    dns
    base64
    eqaf
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = dns.meta // {
    description = "TSIG support for DNS";
  };
}
