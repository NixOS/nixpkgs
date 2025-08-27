let
  pkgs = import ../../../. { };
  inherit (pkgs) mkShellNoCC sbcl nixfmt-rfc-style;
in
mkShellNoCC {
  packages = [
    nixfmt-rfc-style
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
