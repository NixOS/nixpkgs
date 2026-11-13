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
  ppx_expect,
}:

buildDunePackage (finalAttrs: {
  pname = "cohttp";
  version =
    if lib.versionAtLeast ocaml.version "5.2" then
      "6.3.0"
    else if lib.versionAtLeast ocaml.version "4.13" then
      "6.2.1"
    else
      "5.3.1";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${finalAttrs.version}/cohttp-${finalAttrs.version}.tbz";
    hash =
      {
        "6.3.0" = "sha256-MRMPaKnwpc2NcbVfBCRW5tNb+LeranGrbXvX29tgeyQ=";
        "6.2.1" = "sha256-ZQgCR3Y0QtHcPNkGeLgjO3mHcvA2rIHNHqreH11mpl8=";
        "5.3.1" = "sha256-9eJz08Lyn/R71+Ftsj4fPWzQGkC+ACCJhbxDTIjUV2s=";
      }
      ."${finalAttrs.version}";
  };

  postPatch = ''
    substituteInPlace cohttp/src/dune --replace-warn 'bytes base64' 'base64'
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
  ++ [
    (if lib.versionOlder finalAttrs.version "6.0.0" then crowbar else ppx_expect)
  ];

  meta = {
    description = "HTTP(S) library for Lwt, Async and Mirage";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-cohttp";
  };
})
