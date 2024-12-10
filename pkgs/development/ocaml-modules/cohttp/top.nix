{
  lib,
  buildDunePackage,
  cohttp,
}:

buildDunePackage {
  pname = "cohttp-top";
  inherit (cohttp) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ cohttp ];

  doCheck = true;

  meta = cohttp.meta // {
    description = "CoHTTP toplevel pretty printers for HTTP types";
  };
}
