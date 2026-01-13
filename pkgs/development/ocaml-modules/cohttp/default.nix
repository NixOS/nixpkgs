{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  ppx_sexp_conv,
  base64,
  jsonm,
  http,
  logs,
  re,
  stringext,
  ipaddr,
  uri-sexp,
  fmt,
  alcotest,
  crowbar,
}:

buildDunePackage (finalAttrs: {
  pname = "cohttp";
  version = if lib.versionAtLeast ocaml.version "4.13" then "6.2.0" else "5.3.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${finalAttrs.version}/cohttp-${finalAttrs.version}.tbz";
    hash =
      {
        "6.2.0" = "sha256-bwV1TK8z1rdeii4aISDKe1Ag4TiLwgJIRC0TOZNt3zs=";
        "5.3.1" = "sha256-9eJz08Lyn/R71+Ftsj4fPWzQGkC+ACCJhbxDTIjUV2s=";
      }
      ."${finalAttrs.version}";
  };

  postPatch = ''
    substituteInPlace cohttp/src/dune --replace 'bytes base64' 'base64'
  '';

  buildInputs = [
    ppx_sexp_conv
  ]
  ++ lib.optionals (lib.versionOlder finalAttrs.version "6.0.0") [
    jsonm
  ];

  propagatedBuildInputs = [
    base64
    re
    stringext
    uri-sexp
  ]
  ++ lib.optionals (lib.versionAtLeast finalAttrs.version "6.0.0") [
    http
    ipaddr
    logs
  ];

  doCheck = true;
  checkInputs = [
    fmt
    alcotest
  ]
  ++ lib.optionals (lib.versionOlder finalAttrs.version "6.0.0") [
    crowbar
  ];

  meta = {
    description = "HTTP(S) library for Lwt, Async and Mirage";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-cohttp";
  };
})
