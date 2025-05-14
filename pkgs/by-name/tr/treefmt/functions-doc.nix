{
  nixdoc,
  runCommand,
}:
{
  markdown =
    runCommand "treefmt-functions-doc"
      {
        nativeBuildInputs = [ nixdoc ];
      }
      ''
        nixdoc --file ${./lib.nix} \
          --description "Functions Reference" \
          --prefix "pkgs" \
          --category "treefmt" \
          --anchor-prefix "" \
           > $out
      '';
}
