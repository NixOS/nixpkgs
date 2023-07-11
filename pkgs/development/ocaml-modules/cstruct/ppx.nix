{ lib, buildDunePackage, cstruct, sexplib, ppxlib, stdlib-shims
, ounit, cppo, ppx_sexp_conv, cstruct-unix, cstruct-sexp
}:

if lib.versionOlder (cstruct.version or "1") "3"
then cstruct
else

  buildDunePackage {
    pname = "ppx_cstruct";
    inherit (cstruct) version src meta;

    minimalOCamlVersion = "4.08";
    duneVersion = "3";

    propagatedBuildInputs = [ cstruct ppxlib sexplib stdlib-shims ];

    doCheck = true;
    nativeCheckInputs = [ cppo ];
    checkInputs = [ ounit ppx_sexp_conv cstruct-sexp cstruct-unix ];
  }
