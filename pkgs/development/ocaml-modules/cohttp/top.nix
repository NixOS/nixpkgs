{
  buildDunePackage,
  cohttp,
  ppx_expect,
}:

buildDunePackage {
  pname = "cohttp-top";
  inherit (cohttp) version src;

  propagatedBuildInputs = [ cohttp ];

  doCheck = true;
  checkInputs = [ ppx_expect ];

  meta = cohttp.meta // {
    description = "CoHTTP toplevel pretty printers for HTTP types";
  };
}
