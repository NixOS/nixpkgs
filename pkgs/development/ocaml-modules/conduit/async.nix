{ lib, buildDunePackage, async, async_ssl, ppx_sexp_conv, ppx_here, uri, conduit }:

buildDunePackage {
  pname = "conduit-async";
  inherit (conduit)
    version
    src
    minimumOCamlVersion
    useDune2
    ;

  buildInputs = [ ppx_sexp_conv ppx_here ];

  propagatedBuildInputs = [ async async_ssl conduit uri ];

  meta = conduit.meta // {
    description = "A network connection establishment library for Async";
  };
}
