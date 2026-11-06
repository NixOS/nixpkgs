{
  stdenv,
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
  julia_113-bin = wrapJulia (
    callPackage (import ./generic-bin.nix {
      version = "1.13.3";
      sha256 = {
        x86_64-linux = "1r33bkw1657h37nns4d1lk597h6sypi7jxsfa2ivab1k815wnqaw";
        aarch64-linux = "00yz3lbsz16xzjjh33dcizzvgag3bn9ddbs0pn4q3yvdxqxhbsww";
        aarch64-darwin = "0r9pmp20lkq8z1z5sw5z65d6d4wrq0gzlhwb7sm95cxw1x2yiw5r";
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
          # stackwalk: derive glibc longjmp pointer mangling
          # https://github.com/JuliaLang/julia/pull/62775
          # Probably not needed after the next release on this branch (1.10.13+)
          (fetchpatch2 {
            url = "https://github.com/JuliaLang/julia/commit/cf08907c8fc7ffc64dc664e2dd7469707824b601.patch?full_index=1";
            hash = "sha256-1Dq5gEo+MiBoIZq8xBHNONwDrwLLQ3Yr6qQh6EJKCCQ=";
          })
        ];
      })
      {
        stdenv = gcc14Stdenv;
        gfortran = gfortran14;
      }
  );
  julia_113 = wrapJulia (
    callPackage
      (import ./generic.nix {
        version = "1.13.3";
        hash = "sha256-E8TNBnli1sgf6mAIGSW+nimSpCBCicww3uPd2Wks8xs=";
        patches = [
          # Upstream only sets CMAKE_BUILD_RPATH on Darwin (JuliaLang/julia#63103).
          # On Linux in the Nix sandbox, intermediate build tools like llvm-min-tblgen
          # need build_shlibdir in RPATH to find bundled libz/libzstd during LLVM compilation.
          ./patches/1.13/0001-llvm-zlib-rpath.patch
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
