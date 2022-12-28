{ lib, buildDunePackage, async, async_ssl, ppx_sexp_conv, ppx_here, uri, conduit
, core, ipaddr, ipaddr-sexp, sexplib
}:

buildDunePackage {
  pname = "conduit-async";
  inherit (conduit)
    version
    src
    ;

  buildInputs = [ ppx_sexp_conv ppx_here ];

  propagatedBuildInputs = [
    async
    async_ssl
    conduit
    uri
    ipaddr
    ipaddr-sexp
    core
    sexplib
  ];

  meta = conduit.meta // {
    description = "A network connection establishment library for Async";
  };
}
