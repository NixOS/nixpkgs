{
  lib,
  buildDunePackage,
  cohttp,
  ipaddr,
  lwt,
  uri,
  ppx_sexp_conv,
  logs,
  sexplib0,
}:

buildDunePackage {
  pname = "cohttp-lwt";
  inherit (cohttp)
    version
    src
    ;

  buildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    cohttp
    lwt
    logs
    sexplib0
    uri
  ]
  ++ lib.optionals (lib.versionAtLeast cohttp.version "6.0.0") [
    ipaddr
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation using the Lwt concurrency library";
  };
}
