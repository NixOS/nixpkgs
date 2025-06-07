{
  buildDunePackage,
  cohttp,
  eio,
  fmt,
  http,
  logs,
  ptime,
  uri,
}:

buildDunePackage {
  pname = "cohttp-eio";
  inherit (cohttp)
    version
    src
    ;

  minimalOCamlVersion = "5.1";

  duneVersion = "3";

  propagatedBuildInputs = [
    cohttp
    eio
    fmt
    http
    logs
    ptime
    uri
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation with eio backend";
  };
}
