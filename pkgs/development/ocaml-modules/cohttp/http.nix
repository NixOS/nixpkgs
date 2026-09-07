{
  buildDunePackage,
  cohttp,
}:

buildDunePackage {
  pname = "http";
  inherit (cohttp)
    version
    src
    ;

  minimalOCamlVersion = "5.1";

  meta = cohttp.meta // {
    description = "CoHTTP implementation using the Lwt concurrency library";
  };
}
