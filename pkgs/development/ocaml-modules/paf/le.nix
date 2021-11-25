{ lib
, buildDunePackage
, paf
, duration
, emile
, httpaf
, letsencrypt
, mirage-stack
, mirage-time
, tls-mirage
}:

buildDunePackage {
  pname = "paf-le";

  inherit (paf)
    version
    src
    useDune2
    minimumOCamlVersion
  ;

  propagatedBuildInputs = [
    paf
    duration
    emile
    httpaf
    letsencrypt
    mirage-stack
    mirage-time
    tls-mirage
  ];

  doCheck = true;

  meta = paf.meta // {
    description = "A CoHTTP client with its HTTP/AF implementation";
  };
}
