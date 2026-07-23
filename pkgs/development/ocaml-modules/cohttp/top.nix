{ buildDunePackage, cohttp }:

buildDunePackage {
  pname = "cohttp-top";
  inherit (cohttp) version src;

  propagatedBuildInputs = [ cohttp ];

  doCheck = true;

  meta = cohttp.meta // {
    description = "CoHTTP toplevel pretty printers for HTTP types";
  };
}
