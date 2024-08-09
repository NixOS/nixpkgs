{ pkgs, cargoHashOrLock }:

let
  sgconfigYml = (pkgs.formats.yaml { }).generate "sgconfig.yml" {
    ruleDirs = [ "rules" ];
    customLanguages.nix = {
      libraryPath = "${pkgs.tree-sitter-grammars.tree-sitter-nix}/parser";
      extensions = [ "nix" ];
    };
  };
  ruleYml = (pkgs.formats.yaml { }).generate "cargoHashOrLock.yml" {
    id = "cargo-hash-or-lock";
    language = "nix";
    files = [ "./package.nix" ];
    rule = {
      kind = "binding";
      regex = "cargoHash\\s*=|cargoLock\\s*=";
    };
    fix = cargoHashOrLock;
  };
in
pkgs.stdenvNoCC.mkDerivation {
  name = "sgconfig";
  src = pkgs.emptyDirectory;
  installPhase = ''
    mkdir -p $out
    cp '${sgconfigYml}' $out/sgconfig.yml
    mkdir -p $out/rules
    cp '${ruleYml}' $out/rules/cargoHash.yml
  '';
}
