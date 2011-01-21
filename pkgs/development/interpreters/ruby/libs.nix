{stdenv, getConfig, fetchurl, callPackage}:

let
  inherit (stdenv.lib) fold optional;
  gemsMergeableFun = { generatedFuns ? [], patchFuns ? [], overrideFuns ? [] }:
  let
    generatedAttrs = map (f: f customGems) generatedFuns;
    generatedGems = map (a: a.gems) generatedAttrs;
    gem = callPackage ./gem.nix {
      patches = map (f: callPackage f { inherit gems; }) patchFuns;
      overrides = map (f: callPackage f { }) overrideFuns;
    };
    customGems = stdenv.lib.mapAttrs gem (fold (x: y: x // y) { } generatedGems);
    gems = fold (x: y: x // y) customGems (map (a: a.aliases) generatedAttrs);
  in
  gems // {
    merge = { generated ? null, patches ? null, overrides ? null }:
      gemsMergeableFun {
        generatedFuns = generatedFuns ++ optional (generated != null) generated;
        patchFuns = patchFuns ++ optional (patches != null) patches;
        overrideFuns = overrideFuns ++ optional (overrides != null) overrides;
      };
  };
in
((gemsMergeableFun { }).merge {
  generated = import ./generated.nix;
  patches = import ./patches.nix;
  overrides = import ./overrides.nix;
}).merge {
  generated = getConfig [ "gems" "generated" ] null;
  patches = getConfig [ "gems" "patches" ] null;
  overrides = getConfig [ "gems" "overrides" ] null;
}
