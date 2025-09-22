{ callPackage, fetchpatch2 }:

let
  juliaWithPackages = callPackage ../../julia-modules { };

  wrapJulia =
    julia:
    julia.overrideAttrs (oldAttrs: {
      passthru = (oldAttrs.passthru or { }) // {
        withPackages = juliaWithPackages.override { inherit julia; };
      };
    });

in

{
  julia_19-bin = wrapJulia (
    callPackage (import ./generic-bin.nix {
      version = "1.9.4";
      sha256 = {
        x86_64-linux = "07d20c4c2518833e2265ca0acee15b355463361aa4efdab858dad826cf94325c";
        aarch64-linux = "541d0c5a9378f8d2fc384bb8595fc6ffe20d61054629a6e314fb2f8dfe2f2ade";
        x86_64-darwin = "67eec264f6afc9e9bf72c0f62c84d91c2ebdfaed6a0aa11606e3c983d278b441";
        aarch64-darwin = "67542975e86102eec95bc4bb7c30c5d8c7ea9f9a0b388f0e10f546945363b01a";
      };
      patches = [
        # https://github.com/JuliaLang/julia/commit/f5eeba35d9bf20de251bb9160cc935c71e8b19ba
        ./patches/1.9-bin/0001-allow-skipping-internet-required-tests.patch
      ];
    }) { }
  );
  julia_110-bin = wrapJulia (
    callPackage (import ./generic-bin.nix {
      version = "1.10.10";
      sha256 = {
        x86_64-linux = "6a78a03a71c7ab792e8673dc5cedb918e037f081ceb58b50971dfb7c64c5bf81";
        aarch64-linux = "a4b157ed68da10471ea86acc05a0ab61c1a6931ee592a9b236be227d72da50ff";
        x86_64-darwin = "942b0d4accc9704861c7781558829b1d521df21226ad97bd01e1e43b1518d3e6";
        aarch64-darwin = "52d3f82c50d9402e42298b52edc3d36e0f73e59f81fc8609d22fa094fbad18be";
      };
    }) { }
  );
  julia_111-bin = wrapJulia (
    callPackage (import ./generic-bin.nix {
      version = "1.11.7";
      sha256 = {
        x86_64-linux = "aa5924114ecb89fd341e59aa898cd1882b3cb622ca4972582c1518eff5f68c05";
        aarch64-linux = "f97f80b35c12bdaf40c26f6c55dbb7617441e49c9e6b842f65e8410a388ca6f4";
        x86_64-darwin = "b2c11315df39da478ab0fa77fb228f3fd818f1eaf42dc5cc1223c703f7122fe5";
        aarch64-darwin = "74df9d4755a7740d141b04524a631e2485da9d65065d934e024232f7ba0790b6";
      };
    }) { }
  );
  julia_19 = wrapJulia (
    callPackage (import ./generic.nix {
      version = "1.9.4";
      hash = "sha256-YYQ7lkf9BtOymU8yd6ZN4ctaWlKX2TC4yOO8DpN0ACQ=";
      patches = [
        ./patches/1.9/0002-skip-failing-and-flaky-tests.patch
      ];
    }) { }
  );
  julia_110 = wrapJulia (
    callPackage (import ./generic.nix {
      version = "1.10.10";
      hash = "sha256-/NTIGLlcNu4sI1rICa+PS/Jn+YnWi37zFBcbfMnv3Ys=";
      patches = [
        ./patches/1.10/0002-skip-failing-and-flaky-tests.patch
        # Revert https://github.com/JuliaLang/julia/pull/55354
        # [build] Some improvements to the LLVM build system
        # Related: https://github.com/JuliaLang/julia/issues/55617
        (fetchpatch2 {
          url = "https://github.com/JuliaLang/julia/commit/0be37db8c5b5a440bd9a11960ae9c998027b7337.patch";
          revert = true;
          hash = "sha256-gXC3LE3AuHMlSdA4dW+rbAhJpSB6ZMaz9X1qrHDPX7Y=";
        })
      ];
    }) { }
  );
  julia_111 = wrapJulia (
    callPackage (import ./generic.nix {
      version = "1.11.7";
      hash = "sha256-puluy9YAV8kdx6mfwbN1F7Nhot+P0cRv/a0dm86Jln0=";
      patches = [
        ./patches/1.11/0002-skip-failing-and-flaky-tests.patch
      ];
    }) { }
  );
}
