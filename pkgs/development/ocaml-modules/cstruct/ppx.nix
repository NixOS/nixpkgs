{
  lib,
  buildDunePackage,
  ocaml,
  cstruct,
  sexplib,
  ppxlib,
  ocaml-migrate-parsetree-2,
  crowbar,
  fmt,
  cppo,
  ppx_sexp_conv,
  cstruct-unix,
  cstruct-sexp,
}:

if lib.versionOlder (cstruct.version or "1") "3" then
  cstruct
else

  buildDunePackage {
    pname = "ppx_cstruct";
    inherit (cstruct) version src meta;

    propagatedBuildInputs = [
      cstruct
      ppxlib
      sexplib
    ];

    doCheck = !lib.versionAtLeast ocaml.version "5.1";
    nativeCheckInputs = [ cppo ];
    checkInputs = [
      crowbar
      fmt
      ppx_sexp_conv
      cstruct-sexp
      cstruct-unix
      ocaml-migrate-parsetree-2
    ];
  }
