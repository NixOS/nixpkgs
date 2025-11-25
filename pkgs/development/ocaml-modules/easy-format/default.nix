{
  lib,
  fetchurl,
  ocaml,
  buildDunePackage,
}:

let
  params =
    if lib.versionAtLeast ocaml.version "4.08" then
      {
        version = "1.3.4";
        hash = "sha256-Hb8FHp9oV03ebi4lSma5xSTKQl6As26Zr5btlkq2EMM=";
      }
    else
      {
        version = "1.3.2";
        hash = "sha256-NEDCuILVN65ekBHrBqu1P1Zn5lHqS7O0YOqCMPqMGSY=";
      };
in

buildDunePackage rec {
  pname = "easy-format";
  inherit (params) version;

  src = fetchurl {
    url = "https://github.com/ocaml-community/easy-format/releases/download/${version}/easy-format-${version}.tbz";
    inherit (params) hash;
  };

  doCheck = true;

  meta = {
    description = "High-level and functional interface to the Format module of the OCaml standard library";
    longDescription = ''
      This module offers a high-level and functional interface to the Format module of
      the OCaml standard library. It is a pretty-printing facility, i.e. it takes as
      input some code represented as a tree and formats this code into the most
      visually satisfying result, breaking and indenting lines of code where
      appropriate.

      Input data must be first modelled and converted into a tree using 3 kinds of
      nodes:

      * atoms
      * lists
      * labelled nodes

      Atoms represent any text that is guaranteed to be printed as-is. Lists can model
      any sequence of items such as arrays of data or lists of definitions that are
      labelled with something like "int main", "let x =" or "x:".
    '';
    homepage = "https://github.com/ocaml-community/easy-format";
    changelog = "https://github.com/ocaml-community/easy-format/releases/tag/${params.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
