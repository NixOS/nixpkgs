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

buildDunePackage rec {
  pname = "conduit";
  version = "7.1.0";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v${version}/conduit-${version}.tbz";
    hash = "sha256-WNIhigfnFwYCXeOMoCUyM+lw81tMrNN/cGlBtMvqV/c=";
  };

  propagatedBuildInputs = [
    astring
    ipaddr
    ipaddr-sexp
    sexplib0
    uri
    ppx_sexp_conv
  ];

  meta = with lib; {
    description = "Network connection establishment library";
    license = licenses.isc;
    maintainers = with maintainers; [
      alexfmpe
      vbgl
    ];
    homepage = "https://github.com/mirage/ocaml-conduit";
  };
}
