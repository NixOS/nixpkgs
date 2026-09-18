{
  lib,
  buildDunePackage,
  ocaml,
  alcotest,
  crowbar,
  cstruct,
  sexplib,
}:

if lib.versionOlder (cstruct.version or "1") "3" then
  cstruct
else

  buildDunePackage {
    pname = "cstruct-sexp";
    inherit (cstruct) version src meta;

    doCheck = true;
    checkInputs = [
      alcotest
      crowbar
    ];

    propagatedBuildInputs = [
      cstruct
      sexplib
    ];
  }
