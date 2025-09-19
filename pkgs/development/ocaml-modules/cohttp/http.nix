{
  buildDunePackage,
  cohttp,
  ppx_expect,
}:

buildDunePackage {
  pname = "http";
  inherit (cohttp)
    version
    src
    ;

  propagatedBuildInputs = [ ppx_expect ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation using the Lwt concurrency library";
  };
}
