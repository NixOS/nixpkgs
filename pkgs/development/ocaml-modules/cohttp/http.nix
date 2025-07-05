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

  duneVersion = "3";

  meta = cohttp.meta // {
    description = "CoHTTP implementation using the Lwt concurrency library";
  };
}
