{ pkgs, haskellLib }:

let
  inherit (pkgs) fetchpatch lib;
in

with haskellLib;

(self: super: {
  # cabal2nix doesn't properly add dependencies conditional on os(windows)
  network = lib.pipe super.network [
    (addBuildDepends [ self.temporary ])

    # https://github.com/haskell/network/pull/605
    (appendPatch (fetchpatch {
      name = "dont-frag-wine.patch";
      url = "https://github.com/haskell/network/commit/ecd94408696117d34d4c13031c30d18033504827.patch";
      sha256 = "sha256-8LtAkBmgMMMIW6gPYDVuwYck/4fcOf08Hp2zLmsRW2w=";
    }))
  ];

  # Workaround for
  #   Mingw-w64 runtime failure:
  #   32 bit pseudo relocation at 00000001400EB99E out of range, targeting 00006FFFFFEB8170, yielding the value 00006FFEBFDCC7CE.
  # Root cause seems to be undefined references to libffi as shown by linking errors if we instead use "-Wl,--disable-auto-import"
  # See https://github.com/rust-lang/rust/issues/132226#issuecomment-2445100058
  iserv-proxy = appendConfigureFlag "--ghc-option=-optl=-Wl,--disable-runtime-pseudo-reloc" super.iserv-proxy;

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
