{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;
in

with haskellLib;

self: super: {
  # Avoids a cycle by disabling use of the external interpreter for the packages that are dependencies of iserv-proxy.
  # These in particular can't rely on template haskell for cross-compilation anyway as they can't rely on iserv-proxy.
  inherit
    (
      let
        noExternalInterpreter = overrideCabal {
          enableExternalInterpreter = false;
        };
      in
      lib.mapAttrs (_: noExternalInterpreter) {
        inherit (super)
          iserv-proxy
          libiserv
          network
          random
          splitmix
          temporary
          ;
      }
    )
    iserv-proxy
    libiserv
    network
    # dependencies on windows
    random
    splitmix
    temporary
    ;
}
