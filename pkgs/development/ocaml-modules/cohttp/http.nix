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

  minimalOCamlVersion = "5.1";

  propagatedBuildInputs = [ ppx_expect ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation using the Lwt concurrency library";
  };
}
