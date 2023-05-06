{ lib
, buildDunePackage
, ppx_sexp_conv
, base
, async
, async_kernel
, async_unix
, cohttp
, conduit-async
, core_unix ? null
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

  postPatch = if lib.versionOlder "0.16" async.version then ''
    substituteInPlace "cohttp-async/src/body_raw.ml" --replace \
      "Deferred.List.iter" 'Deferred.List.iter ~how:`Sequential'

    substituteInPlace "cohttp-async/bin/cohttp_server_async.ml" --replace \
      "Deferred.List.map" 'Deferred.List.map ~how:`Sequential'

    substituteInPlace "cohttp-async/src/client.ml" --replace \
      "Deferred.Queue.map" 'Deferred.Queue.map ~how:`Sequential'
  '' else "";

  meta = cohttp.meta // {
    description = "CoHTTP implementation for the Async concurrency library";
  };
}
