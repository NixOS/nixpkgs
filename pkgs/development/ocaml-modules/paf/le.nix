{ lib
, buildDunePackage
, paf
, dns-client-mirage
, duration
, emile
, httpaf
, letsencrypt
, mirage-stack
, mirage-time
, tls-mirage
, x509
}:

buildDunePackage {
  pname = "paf-le";

  inherit (paf)
    version
    src
    patches
  ;

  duneVersion = "3";

  propagatedBuildInputs = [
    paf
    dns-client-mirage
    duration
    emile
    httpaf
    letsencrypt
    mirage-stack
    mirage-time
    tls-mirage
    x509
  ];

  doCheck = true;

  meta = paf.meta // {
    description = "A CoHTTP client with its HTTP/AF implementation";
  };
}
