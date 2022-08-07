{ pkgs, lib, nodejs, stdenv}:

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

  extensions = composeManyExtensions [
    mainProgramOverrides
    (import ./overrides.nix { inherit pkgs nodejs; })
  ];
in
  makeExtensible (extends extensions nodePackages)
