{
  lib,
  ocaml,
  buildDunePackage,
  uri,
  ounit,
  ppx_sexp_conv,
  sexplib0,
}:

buildDunePackage {
  pname = "uri-sexp";
  inherit (uri) version src;

  duneVersion = "3";

  checkInputs = [ ounit ];
  propagatedBuildInputs = [
    ppx_sexp_conv
    sexplib0
    uri
  ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = uri.meta // {
    broken = uri.meta.broken or false || lib.versionOlder ocaml.version "4.04";
  };
}
