{ pkgs, haskellLib }:

let
  inherit (pkgs) fetchpatch lib;
in

with haskellLib;

(self: super: {
  # cabal2nix doesn't properly add dependencies conditional on os(windows)
  http-client = addBuildDepends [ self.safe ] super.http-client;
  network = addBuildDepends [ self.temporary ] super.network;
  unix-time = addBuildDepends [ pkgs.windows.pthreads ] super.unix-time;

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
})
