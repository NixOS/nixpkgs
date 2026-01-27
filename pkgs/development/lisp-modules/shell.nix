let
  pkgs = import ../../../. { };
  inherit (pkgs) mkShellNoCC sbcl nixfmt;
in
mkShellNoCC {
  packages = [
    nixfmt
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
