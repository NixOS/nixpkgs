{ pkgs, haskellLib }:

let
  inherit (pkgs) fetchpatch lib;
in

with haskellLib;

let
  # Avoid a cycle by disabling tests and the external interpreter for packages that are dependencies of iserv-proxy.
  # These in particular can't rely on template haskell for cross-compilation anyway as they can't rely on iserv-proxy.
  # Also disable tests during iserv-proxy bootstrap since test packages tend to rely on TH for discovering test cases
  breakCrossCycle = lib.flip lib.pipe [
    (overrideCabal { enableExternalInterpreter = false; })
    (haskellLib.dontCheckIf (with pkgs.stdenv; buildPlatform != hostPlatform))
  ];
in

(self: super: {
  # cabal2nix doesn't properly add dependencies conditional on os(windows)
  network =
    if pkgs.stdenv.hostPlatform.isWindows then
      addBuildDepends [ self.temporary ] super.network
    else
      super.network;

  # On Windows, network depends on temporary (see above), which depends on random, which depends on splitmix.
  inherit (lib.mapAttrs (_: breakCrossCycle) { inherit (super) random splitmix temporary; })
    random
    splitmix
    temporary
    ;

  # https://github.com/fpco/streaming-commons/pull/84
  streaming-commons = appendPatch (fetchpatch {
    name = "fix-headers-case.patch";
    url = "https://github.com/fpco/streaming-commons/commit/6da611f63e9e862523ce6ee53262ddbc9681ae24.patch";
    sha256 = "sha256-giEQqXZfoiAvtCFohdgOoYna2Tnu5aSYAOUH8YVldi0=";
  }) super.streaming-commons;
})
