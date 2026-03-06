{ pkgs, haskellLib }:

let
  inherit (pkgs) fetchpatch lib;
in

with haskellLib;

(self: super: {
  # cabal2nix doesn't properly add dependencies conditional on os(windows)
  network =
    if pkgs.stdenv.hostPlatform.isWindows then
      addBuildDepends [ self.temporary ] super.network
    else
      super.network;

  # Avoids a cycle by disabling use of the external interpreter for the packages that are dependencies of iserv-proxy.
  # See configuration-nix.nix, where iserv-proxy and network are handled.
  # On Windows, network depends on temporary (see above), which depends on random, which depends on splitmix.
  inherit
    (
      let
        noExternalInterpreter = overrideCabal {
          enableExternalInterpreter = false;
        };
      in
      lib.mapAttrs (_: noExternalInterpreter) { inherit (super) random splitmix temporary; }
    )
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
