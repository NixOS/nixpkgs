{ lib
, buildDunePackage
, ppx_sexp_conv
, base
, async
, async_kernel
, async_unix
, cohttp
, conduit-async
, core_unix
, uri
, uri-sexp
, logs
, fmt
, sexplib0
, ipaddr
, magic-mime
, ounit
, mirage-crypto
, core
}:

buildDunePackage {
  pname = "cohttp-async";

  inherit (cohttp)
    version
    src
    ;

  buildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    cohttp
    conduit-async
    async_kernel
    async_unix
    async
    base
    core_unix
    magic-mime
    logs
    fmt
    sexplib0
    uri
    uri-sexp
    ipaddr
  ];

  doCheck = true;
  checkInputs = [
    ounit
    mirage-crypto
    core
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation for the Async concurrency library";
  };
}
