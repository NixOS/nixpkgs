{
  stdenv,
  lib,
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
      version = "1.10.12";
      sha256 = {
        x86_64-linux = "03dw4zykf09wnzc7mm8yv6k8hfb2pv0f090db34gyxlx6kz0vidh";
        aarch64-linux = "18p5h0h00320rfc3yhjgp9z4f5xfgpzimphpzqmn8jbhjqhpn9fc";
        aarch64-darwin = "0gvqmdnqgs2gv72zsnnppfhbsj7qynvimll9hm4nvm905bp2mcak";
      };
    }) { }
  );
  julia_111-bin = wrapJulia (
    callPackage (import ./generic-bin.nix {
      version = "1.11.9";
      sha256 = {
        x86_64-linux = "0dfy4wlrz6jbs7kd9r0bjk9d6sqgf4fakrxrnzwfl1bsdlsn6qxk";
        aarch64-linux = "0gk2zxkwz2yyg3im23jpgaxzixchyywm19nbh51szmniah31y1x2";
        aarch64-darwin = "1mrvycjlxs225sspdvvq4qbay1riyyjzqjs1d0xgqdkh6c6kv47d";
      };
    }) { }
  );
  julia_112-bin = wrapJulia (
    callPackage (import ./generic-bin.nix {
      version = "1.12.7";
      sha256 = {
        x86_64-linux = "1s39x8l6rgp6jw3b4bj3phaszm5h77g7rrhd4lslililcrvrwzjf";
        aarch64-linux = "1whyfcdf7bncz2n1ixxzf3h30slildgfx8a06a401wy74jsw0hwj";
        aarch64-darwin = "06b9r4a6zddqr1cg9cv206zmjbdaiz1rb5nr2f69qssvnbgwx3xg";
      };
    }) { }
  );
  julia_110 = wrapJulia (
    callPackage
      (import ./generic.nix {
        version = "1.10.12";
        hash = "sha256-KIFenIPyMWflO9SnnAhea5VHrigIrLI0FatcVYqFzuw=";
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
        version = "1.12.7";
        hash = "sha256-XH2Ft3HeMYXuyp+8LmFz2Lz2109oQYYiqenEOtdSr1E=";
        patches = lib.optionals stdenv.hostPlatform.isDarwin [
          ./patches/1.12/0001-zlib-rpath.patch
          ./patches/1.12/0002-lbt-blas-detection.patch
        ];
      })
      (
        if stdenv.cc.isGNU then
          {
            stdenv = gcc14Stdenv;
            gfortran = gfortran14;
          }
        else
          { }
      )
  );
}
