{
  buildDunePackage,
  cohttp,
  eio,
  uri,
  ppx_sexp_conv,
  logs,
  sexplib0,
  ptime,
}:

buildDunePackage {
  pname = "cohttp-eio";
  inherit (cohttp)
    version
    src
    ;

  duneVersion = "3";

  buildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    cohttp
    eio
    logs
    sexplib0
    uri
    ptime
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation using the Lwt concurrency library";
  };
}
