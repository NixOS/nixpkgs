{
  lib,
  fetchurl,
  buildDunePackage,
  ounit,
  ppx_deriving,
  ppx_sexp_conv,
  ppxlib,
  version ?
    if lib.versionAtLeast ppxlib.version "0.36" then
      "1.12.0"
    else if lib.versionAtLeast ppxlib.version "0.26" then
      "1.11.0"
    else if lib.versionAtLeast ppxlib.version "0.24.0" then
      "1.9.1"
    else
      throw "ppx_import is not available with ppxlib-${ppxlib.version}",
}:

buildDunePackage {
  pname = "ppx_import";
  inherit version;

  src = fetchurl {
    url =
      let
        dir = if lib.versionAtLeast version "1.11" then "v${version}" else "${version}";
      in
      "https://github.com/ocaml-ppx/ppx_import/releases/download/${dir}/ppx_import-${version}.tbz";

    hash =
      {
        "1.9.1" = "sha256-0bSY4u44Ds84XPIbcT5Vt4AG/4PkzFKMl9CDGFZyIdI=";
        "1.11.0" = "sha256-Jmfv1IkQoaTkyxoxp9FI0ChNESqCaoDsA7D4ZUbOrBo=";
        "1.12.0" = "sha256-1vpYHFl0rEdG3hE+6BCpWmfLvdLvoEx+Jxq0DFrRdJc=";
      }
      ."${version}";
  };

  propagatedBuildInputs = [
    ppxlib
  ];

  checkInputs = [
    ounit
    ppx_deriving
    ppx_sexp_conv
  ];

  doCheck = true;

  meta = {
    description = "Syntax extension for importing declarations from interface files";
    license = lib.licenses.mit;
    homepage = "https://github.com/ocaml-ppx/ppx_import";
  };
}
