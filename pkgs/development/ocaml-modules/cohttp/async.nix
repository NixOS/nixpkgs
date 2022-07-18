{ lib
, fetchpatch
, fetchurl
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

  # Examples don't compile with core 0.15.  See https://github.com/mirage/ocaml-cohttp/pull/864.
  doCheck = false;
  checkInputs = [
    ounit
    mirage-crypto
    core
  ];

  # Compatibility with core 0.15.  No longer needed after updating cohttp to 5.0.0.
  patches = fetchpatch {
    url = "https://github.com/mirage/ocaml-cohttp/commit/5a7124478ed31c6b1fa6a9a50602c2ec839083b5.patch";
    sha256 = "0i99rl8604xqwb6d0yzk9ws4dflbn0j4hv2nba2qscbqrrn22rw3";
  };
  patchFlags = "-p1 -F3";

  meta = cohttp.meta // {
    description = "CoHTTP implementation for the Async concurrency library";
  };
}
