{
  buildDunePackage,
  cohttp,
  eio,
  fmt,
  http,
  logs,
  ptime,
  uri,
  alcotest,
  ca-certs,
  eio_main,
  ppx_expect,
  tls-eio,
}:

buildDunePackage {
  pname = "cohttp-eio";
  inherit (cohttp)
    version
    src
    ;

  minimalOCamlVersion = "5.1";

  propagatedBuildInputs = [
    cohttp
    eio
    fmt
    http
    logs
    ptime
    uri
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    ca-certs
    eio_main
    ppx_expect
    tls-eio
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation with eio backend";
  };
}
