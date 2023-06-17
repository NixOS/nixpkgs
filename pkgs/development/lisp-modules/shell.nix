let
  pkgs = import ../../../. {};
in pkgs.mkShell {
  nativeBuildInputs = [
    (pkgs.sbcl.withPackages
      (ps: with ps; [
        alexandria
        str
        dexador
        cl-ppcre
        sqlite
        arrow-macros
        jzon
      ]))
  ];
}
