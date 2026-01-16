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

  # Workaround for
  #   Mingw-w64 runtime failure:
  #   32 bit pseudo relocation at 00000001400EB99E out of range, targeting 00006FFFFFEB8170, yielding the value 00006FFEBFDCC7CE.
  # Root cause seems to be undefined references to libffi as shown by linking errors if we instead use "-Wl,--disable-auto-import"
  # See https://github.com/rust-lang/rust/issues/132226#issuecomment-2445100058
  iserv-proxy = appendConfigureFlag "--ghc-option=-optl=-Wl,--disable-runtime-pseudo-reloc" super.iserv-proxy;
})
