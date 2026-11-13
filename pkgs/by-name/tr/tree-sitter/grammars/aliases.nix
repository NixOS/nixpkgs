{ lib }:
_final: prev:
let
  checkInGrammars =
    name: alias:
    if builtins.hasAttr name prev then
      throw "Alias ${name} is still in tree-sitter-grammars"
    else
      alias;

  mapAliases = lib.mapAttrs checkInGrammars;
in
mapAliases {
  # keep-sorted start block=yes
  # keep-sorted end
}
