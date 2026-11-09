{
  lib,
  fetchurl,
  buildDunePackage,
  ppx_sexp_conv,
  sexplib0,
  astring,
  uri,
  ipaddr,
  ipaddr-sexp,
}:

buildDunePackage (finalAttrs: {
  pname = "conduit";
  version = "8.0.0";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v${finalAttrs.version}/conduit-${finalAttrs.version}.tbz";
    hash = "sha256-CmPZEIZbVHOJOhcM2lH2E4j0iOz0xLLtf+nsTiz2b2E=";
  };

  propagatedBuildInputs = [
    astring
    ipaddr
    ipaddr-sexp
    sexplib0
    uri
    ppx_sexp_conv
  ];

  meta = {
    description = "Network connection establishment library";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      vbgl
    ];
    homepage = "https://github.com/mirage/ocaml-conduit";
  };
})
