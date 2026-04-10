let
  # Use CI-pinned (Hydra-cached) packages and formatter,
  # rather than the local nixpkgs checkout.
  inherit (import ../../../ci { }) pkgs fmt;
  inherit (pkgs) mkShellNoCC sbcl;
in
mkShellNoCC {
  packages = [
    fmt.pkg
    (sbcl.withPackages (
      ps:
      builtins.attrValues {
        inherit (ps)
          alexandria
          str
          dexador
          cl-ppcre
          sqlite
          arrow-macros
          jzon
          ;
      }
    ))
  ];
}
