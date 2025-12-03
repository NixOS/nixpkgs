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
  julia_112-bin = wrapJulia (
    callPackage (import ./generic-bin.nix {
      version = "1.12.1";
      sha256 = {
        x86_64-linux = "7d2add9ee74ee2f12b5c268bc194794cc52ea440f8687fbab29db6afefbf69b7";
        aarch64-linux = "2e3d6ca07e251721fa3e0cd3460fc240e60f2a9bd97bae0ea2144f586da19297";
        x86_64-darwin = "7dd841cd853ad64f5e90a4b459631b49ee388891ceaba81857f5b8959392c4b2";
        aarch64-darwin = "cc65620b71a725380e59d0e31dc0b4140f30229b70a4b8eec8e32c222bc54fc1";
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
  julia_112 = wrapJulia (
    callPackage (import ./generic.nix {
      version = "1.12.1";
      hash = "sha256-iR0Wu5HIqU1aY1WoLBf6PCRY64kWDUKEQ6CyobhB6lI=";
    }) { }
  );
}
