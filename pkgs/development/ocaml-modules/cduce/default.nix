{ lib, fetchgit, buildDunePackage, cduce-types, menhir, menhirLib, ocaml, sedlex }:

let
  common = import ./common.nix {
    inherit lib fetchgit;
  };
in

lib.throwIf (lib.versionAtLeast ocaml.version "4.13")
  "cduce is not available for OCaml ${ocaml.version}"

buildDunePackage rec {
  pname = "cduce";

  # opam file say 4.07 but sedlex is 4.08
  minimalOCamlVersion = "4.08";

  inherit (common) src version;

  nativeBuildInputs = [
    menhir
  ];

  propagatedBuildInputs = [
    cduce-types
    menhirLib
    sedlex
  ];

  meta = with lib; common.meta // {
    description = ''
      CDuce is a functional, impure, staticaly typed
       programming language. It features a OCaml-like syntax with built-in constructs for
       extensible records, overloaded functions and XML document and document types.
       Its type system is based on semantic subtyping and features regular expresison
       types.
    '';
  };
}
