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
  julia_112-bin = wrapJulia (
    callPackage (import ./generic-bin.nix {
      version = "1.12.4";
      sha256 = {
        x86_64-linux = "0pcq75k0vg1gdl39p3chszwmlcig91nkj98srdm94h71iwbsyyy5";
        aarch64-linux = "1p9xcv4sz69wry29vww0kvyy4hr7czf6fxg4d3yj84lkxvgs40m6";
        x86_64-darwin = "15zl9gqca1c5ss95xmqrk9j0hihm9y926wvafyxg5802ndd4jd1c";
        aarch64-darwin = "03vyvn7d5nkz0p7kgypa6c9l44ir6512sbrqdzl04havxc6v4ipa";
      };
    }) { }
  );
  julia_110 = wrapJulia (
    callPackage (import ./generic.nix {
      version = "1.10.10";
      hash = "sha256-/NTIGLlcNu4sI1rICa+PS/Jn+YnWi37zFBcbfMnv3Ys=";
      patches = [
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
    }) { }
  );
  julia_112 = wrapJulia (
    callPackage (import ./generic.nix {
      version = "1.12.1";
      hash = "sha256-iR0Wu5HIqU1aY1WoLBf6PCRY64kWDUKEQ6CyobhB6lI=";
    }) { }
  );
}
