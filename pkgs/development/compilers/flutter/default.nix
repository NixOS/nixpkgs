{
  callPackage,
  lib,
  useNixpkgsEngine ? false,
}:

let
  getPatches =
    dir:
    if builtins.pathExists dir then
      map (fileName: dir + "/${fileName}") (builtins.attrNames (builtins.readDir dir))
    else
      [ ];

  makeFlutterScope = callPackage ./scope.nix { };

  allVersions = lib.mapAttrs' (versionName: _: {
    name = "v${versionName}";
    value =
      let
        versionDir = ./versions + "/${versionName}";
        versionData = lib.importJSON (versionDir + "/data.json");
        globalPatches = getPatches ./patches;
        versionPatches = getPatches (versionDir + "/patches");
        globalEnginePatches = getPatches ./engine/patches;
        versionEnginePatches = getPatches (versionDir + "/engine/patches");
      in
      makeFlutterScope (
        versionData
        // {
          inherit useNixpkgsEngine;
          patches = globalPatches ++ versionPatches;
          enginePatches = globalEnginePatches ++ versionEnginePatches;
        }
      );
  }) (builtins.readDir ./versions);

  getLatestForChannel =
    channel:
    let
      channelVersions = lib.filterAttrs (_: scope: scope.channel == channel) allVersions;
      sortedNames = lib.naturalSort (builtins.attrNames channelVersions);
    in
    if sortedNames == [ ] then null else channelVersions.${lib.last sortedNames}.flutter;

  stable = getLatestForChannel "stable";
  beta = getLatestForChannel "beta";
in
(lib.mapAttrs (_: scope: scope.flutter) allVersions)
// lib.optionalAttrs (stable != null) { inherit stable; }
// lib.optionalAttrs (beta != null) { inherit beta; }
