<<<<<<< HEAD
{ lib, buildDunePackage, cstruct, sexplib, ppxlib
, ocaml-migrate-parsetree-2
=======
{ lib, buildDunePackage, cstruct, sexplib, ppxlib, stdlib-shims
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ounit, cppo, ppx_sexp_conv, cstruct-unix, cstruct-sexp
}:

if lib.versionOlder (cstruct.version or "1") "3"
then cstruct
else

  buildDunePackage {
    pname = "ppx_cstruct";
    inherit (cstruct) version src meta;

    minimalOCamlVersion = "4.08";
<<<<<<< HEAD

    propagatedBuildInputs = [ cstruct ppxlib sexplib ];

    doCheck = true;
    nativeCheckInputs = [ cppo ];
    checkInputs = [ ounit ppx_sexp_conv cstruct-sexp cstruct-unix ocaml-migrate-parsetree-2 ];
=======
    duneVersion = "3";

    propagatedBuildInputs = [ cstruct ppxlib sexplib stdlib-shims ];

    doCheck = true;
    nativeCheckInputs = [ cppo ];
    checkInputs = [ ounit ppx_sexp_conv cstruct-sexp cstruct-unix ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  }
