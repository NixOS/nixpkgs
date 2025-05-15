let
  lib = import ../../../../lib;
  inherit (lib) evalModules;

  # NOTE: move to cudaLib
  intreeManifests =
    let
      root = ../.;
    in
    lib.concatMap (
      name:
      let
        manifestsDir = root + "/${name}/manifests";
        children = lib.attrsToList (builtins.readDir manifestsDir);
        isManifest = { name, value }: value == "regular" && lib.hasSuffix ".json" name;
        entToPath = { name, ... }: manifestsDir + "/${name}";
        manifests = map entToPath (builtins.filter isManifest children);
      in
      lib.optionals (lib.pathIsDirectory manifestsDir) manifests
    ) (builtins.attrNames (builtins.readDir root));
  jsonToModule = import ./json.nix { inherit lib; };
  parseReleasesFile = import ./release_file.nix { inherit lib; };
in
{
  manifests ? intreeManifests, # :: List Path
  extraModules ? [ ],
}:
let
  manifestModules = builtins.map jsonToModule manifests;
  releasesModules = builtins.map parseReleasesFile [
    ../tensorrt/releases.nix
  ];
in
evalModules {
  modules =
    extraModules
    ++ releasesModules
    ++ manifestModules
    ++ [
      ./schema.nix
    ];
}
// {
  inherit intreeManifests;
}
