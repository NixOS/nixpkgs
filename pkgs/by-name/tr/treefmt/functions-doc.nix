{
  lib,
  writers,
  nixdoc,
  runCommand,
  treefmt,
}:
let
  root = toString ./.;
  revision = lib.trivial.revisionWithDefault "master";
  removeRoot = file: lib.removePrefix "/" (lib.removePrefix root file);

  # Import and apply `./lib.nix`, which contains treefmt's public functions
  #
  # NOTE: we cannot access them via `treefmt.passthru` or `callPackages ./lib.nix { }`,
  # because that would be opaque to `unsafeGetAttrPos`.
  attrs =
    let
      fn = import ./lib.nix;
      args = builtins.mapAttrs (_: _: null) (builtins.functionArgs fn);
    in
    fn args;
in
{
  locations = lib.pipe attrs [
    builtins.attrNames
    (map (
      name:
      let
        pos = builtins.unsafeGetAttrPos name attrs;
        file = removeRoot pos.file;
        line = toString pos.line;
        subpath = "pkgs/by-name/tr/treefmt/${file}";
        url = "https://github.com/NixOS/nixpkgs/blob/${revision}/${subpath}#L${line}";
      in
      assert lib.hasPrefix root pos.file;
      lib.nameValuePair "pkgs.treefmt.${name}" "[${subpath}:${line}](${url}) in `<nixpkgs>`"
    ))
    builtins.listToAttrs
    (writers.writeJSON "treefmt-function-locations")
  ];

  markdown =
    runCommand "treefmt-functions-doc"
      {
        nativeBuildInputs = [ nixdoc ];
      }
      ''
        nixdoc --file ${./lib.nix} \
          --locs ${treefmt.functionsDoc.locations} \
          --description "Functions Reference" \
          --prefix "pkgs" \
          --category "treefmt" \
          --anchor-prefix "" \
           > $out
      '';
}
