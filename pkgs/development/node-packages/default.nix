{
  config,
  pkgs,
  lib,
  nodejs,
  stdenv,
}:

let
  inherit (lib)
    composeManyExtensions
    extends
    makeExtensible
    ;

  nodePackages =
    final:
    import ./composition.nix {
      inherit pkgs nodejs;
      inherit (stdenv.hostPlatform) system;
    };

  aliases =
    final: prev: lib.optionalAttrs config.allowAliases (import ./aliases.nix pkgs lib final prev);

  extensions = composeManyExtensions [
    aliases
    (import ./overrides.nix { inherit pkgs nodejs; })
  ];
in
makeExtensible (extends extensions nodePackages)
