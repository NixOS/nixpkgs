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

  duneVersion = "3";

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

  # Examples don't compile with core 0.15.  See https://github.com/mirage/ocaml-cohttp/pull/864.
  doCheck = false;
  checkInputs = [
    ounit
    mirage-crypto
    core
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation for the Async concurrency library";
  };
}
