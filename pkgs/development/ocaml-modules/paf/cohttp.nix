{ lib
, buildDunePackage
, paf
, cohttp-lwt
, domain-name
, httpaf
, ipaddr
, alcotest-lwt
, fmt
, logs
, mirage-crypto-rng
, mirage-time-unix
, tcpip
, uri
, lwt
}:

buildDunePackage {
  pname = "paf-cohttp";

  inherit (paf)
    version
    src
    useDune2
    minimumOCamlVersion
  ;

  propagatedBuildInputs = [
    paf
    cohttp-lwt
    domain-name
    httpaf
    ipaddr
  ];

  doCheck = true;
  checkInputs = [
    alcotest-lwt
    fmt
    logs
    mirage-crypto-rng
    mirage-time-unix
    tcpip
    uri
    lwt
  ];

  meta = paf.meta // {
    description = "A CoHTTP client with its HTTP/AF implementation";
  };
}
