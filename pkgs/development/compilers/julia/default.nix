{
  callPackage,
  fetchpatch2,
  gcc14Stdenv,
  gfortran14,
}:

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
      version = "1.11.9";
      sha256 = {
        x86_64-linux = "0dfy4wlrz6jbs7kd9r0bjk9d6sqgf4fakrxrnzwfl1bsdlsn6qxk";
        aarch64-linux = "0gk2zxkwz2yyg3im23jpgaxzixchyywm19nbh51szmniah31y1x2";
        x86_64-darwin = "14nz5qf9raida260srcmh7p41xdylipx5n61nbx9sf12vcyrrd7p";
        aarch64-darwin = "1mrvycjlxs225sspdvvq4qbay1riyyjzqjs1d0xgqdkh6c6kv47d";
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
    callPackage
      (import ./generic.nix {
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
      })
      {
        stdenv = gcc14Stdenv;
        gfortran = gfortran14;
      }
  );
  julia_111 = wrapJulia (
    callPackage
      (import ./generic.nix {
        version = "1.11.9";
        hash = "sha256-SX5jIfJfxQQfP2P5sCGtglFn+GZlOIyHgnQ3qrr8GSI=";
      })
      {
        stdenv = gcc14Stdenv;
        gfortran = gfortran14;
      }
  );
  julia_112 = wrapJulia (
    callPackage
      (import ./generic.nix {
        version = "1.12.4";
        hash = "sha256-bqYMBTleKQErY5NOaGsNqhzBVZR75CmuCyR7PqfnvpM=";
      })
      {
        stdenv = gcc14Stdenv;
        gfortran = gfortran14;
      }
  );
}
