{
  list,
  baseRid,
  otherRids,
  pkgs ? import ../../../.. {}
}:
with pkgs.lib;
let
  inherit (pkgs) writeText;

  fns = map (file: import file) list;
  packages = unique
    (concatMap (fn: fn { fetchNuGet = package: package; }) fns);

  changePackageRid = package: rid:
    let replace = replaceStrings [".${baseRid}"] [".${rid}"];
    in rec {
      pname = replace package.pname;
      inherit (package) version;
      url = replace package.url;
      sha256 = builtins.hashFile "sha256" (builtins.fetchurl url);
    };

  expandPackage = package:
    [ package ] ++
    optionals (strings.match ".*\\.${baseRid}(\\..*|$)" package.pname != null)
    (map (changePackageRid package) otherRids);

  allPackages =
    sortOn (package: [ package.pname package.version package ])
    (concatMap expandPackage packages);

  fetchExpr = package:
    "  (fetchNuGet ${generators.toPretty { multiline = false; } package})";

in writeText "deps.nix" ''
  { fetchNuGet }: [
  ${concatMapStringsSep "\n" fetchExpr allPackages}
  ]
''
