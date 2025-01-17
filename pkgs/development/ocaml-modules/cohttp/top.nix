{
  buildDunePackage,
  cohttp,
  ppx_expect,
}:

buildDunePackage {
  pname = "cohttp-top";
  inherit (cohttp) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ cohttp ];

  checkInputs = [ ppx_expect ];

  doCheck = true;

  meta = cohttp.meta // {
    description = "CoHTTP toplevel pretty printers for HTTP types";
  };
}
