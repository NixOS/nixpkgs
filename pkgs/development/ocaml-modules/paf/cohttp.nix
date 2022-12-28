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
, astring
}:

buildDunePackage {
  pname = "paf-cohttp";

  inherit (paf)
    version
    src
  ;

  duneVersion = "3";

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
    astring
  ];

  meta = paf.meta // {
    description = "A CoHTTP client with its HTTP/AF implementation";
  };
}
