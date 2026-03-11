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
      version = "1.10.11";
      sha256 = {
        x86_64-linux = "1grpvdzkh4b6mfdn1khbs1nz1b7q61rkzfip3q2x4330fjqwcjgv";
        aarch64-linux = "1cn62bmrgz344zsml80rqpmryp8hk6bdni3zhh43lpqf8a0aj11h";
        x86_64-darwin = "0jzk0kl1jvnav8ccarpwzfvyyzibfhrhfj72s3q17kzxwhpgbimx";
        aarch64-darwin = "0nzh0zwjlagn4aglimyajmqv5m6qwdqz7lyjaszfxzyf1p0hcmxx";
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
      version = "1.12.5";
      sha256 = {
        x86_64-linux = "1rxsb2bnk2wgd2nkzxwpj1xj8gbpblczm4lyxprzp5jfgrr4vf21";
        aarch64-linux = "1qp8ydagd39c1rcj9ryrq0y1hcimw1dgmaaviaqbyqj4x92fhp9f";
        x86_64-darwin = "1b8mdpy6ww89xngsl1q3ym245iyw59alki9cvnplcbg3iqjhgdz4";
        aarch64-darwin = "01fli18s43p74hb7z2fcv8sv72pijp3k1azba6rjjpgfic7f1h0z";
      };
    }) { }
  );
  julia_110 = wrapJulia (
    callPackage
      (import ./generic.nix {
        version = "1.10.11";
        hash = "sha256-XItQngSzszyIGzSvqdXBV/yLQGDxf5x8SnrQ/DtzUtU=";
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
        version = "1.12.5";
        hash = "sha256-3jvzaT2TjX4VU5pcOsIXfFRqzQ17e8TjJ+MNanI48eM=";
      })
      {
        stdenv = gcc14Stdenv;
        gfortran = gfortran14;
      }
  );
}
