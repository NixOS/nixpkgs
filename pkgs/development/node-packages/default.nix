{ config, pkgs, lib, nodejs, stdenv, inspectedSrcTypesJSONExtension }:

let
  inherit (lib) composeManyExtensions extends makeExtensible mapAttrs;

  nodePackages = final: import ./composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  mainProgramOverrides = final: prev:
    mapAttrs (pkgName: mainProgram:
      prev.${pkgName}.override (oldAttrs: {
        meta = oldAttrs.meta // { inherit mainProgram; };
      })
    ) (import ./main-programs.nix);

  aliases = final: prev:
    lib.optionalAttrs config.allowAliases
      (import ./aliases.nix pkgs lib final prev);

  extensions = composeManyExtensions [
    aliases
    (inspectedSrcTypesJSONExtension ./inspected-src-types.generated.json)
    mainProgramOverrides
    (import ./overrides.nix { inherit pkgs nodejs; })
  ];
in
  makeExtensible (extends extensions nodePackages)
