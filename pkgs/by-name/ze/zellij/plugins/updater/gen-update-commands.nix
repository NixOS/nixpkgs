{
  pkgsPath ? ./.,
}:
let
  pkgs = import pkgsPath { };
  inherit (pkgs) lib;

  filtered = lib.filterAttrs (
    name: value: lib.isDerivation value && name != "_updater"
  ) pkgs.zellijPlugins;

  genCommand =
    name: plugin: "nix-update 'zellijPlugins.${name}.unwrapped' ${plugin.updateScriptArgs or ""}";
in
lib.mapAttrsToList genCommand filtered
