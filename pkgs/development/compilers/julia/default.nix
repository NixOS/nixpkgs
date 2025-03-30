{ callPackage, fetchpatch2 }:

let
  juliaWithPackages = callPackage ../../julia-modules { };

  wrapJulia = julia: julia.overrideAttrs (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      withPackages = juliaWithPackages.override { inherit julia; };
    };
  });

in

{
  julia_19-bin = wrapJulia (callPackage
    (import ./generic-bin.nix {
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
    })
    { });
  julia_110-bin = wrapJulia (callPackage
    (import ./generic-bin.nix {
      version = "1.10.9";
      sha256 = {
        x86_64-linux = "5a2d2c5224594b683c97e7304cb72407fbcf0be4a0187789cba1a2f73f0cbf09";
        aarch64-linux = "be222882e3674f960f43b6842f7bbb52a369977e40d5dcd26498793e1cd2dfb6";
        x86_64-darwin = "f80c93c30a18d8a5dc7f37d0cc94757fd3857651268e4a9e2d42d3b1ea3372f1";
        aarch64-darwin = "e62e00b22408159cba3d669f2d9e8b60c1d23b5c2d1c22ec25f4957d15ca98ef";
      };
    })
    { });
  julia_111-bin = wrapJulia (callPackage
    (import ./generic-bin.nix {
      version = "1.11.4";
      sha256 = {
        x86_64-linux = "fb3d3c5fccef82158a70677c0044ac5ae40410eceb0604cdc8e643eeff21df8d";
        aarch64-linux = "859f1a8cc4bce6911bc912f0e226a6ba2b1c144110b9d559d88f5077513d0e37";
        x86_64-darwin = "7e693914399f2ebe1fafe5c670af0373474145cfe2bfda661f370559a680720a";
        aarch64-darwin = "5adfb4482bba9610405c0f9b5a3c1aa09cabf70c8751d75970f2dab0fa819488";
      };
    })
    { });
  julia_19 = wrapJulia (callPackage
    (import ./generic.nix {
      version = "1.9.4";
      hash = "sha256-YYQ7lkf9BtOymU8yd6ZN4ctaWlKX2TC4yOO8DpN0ACQ=";
      patches = [
        ./patches/1.9/0002-skip-failing-and-flaky-tests.patch
      ];
    })
    { });
  julia_110 = wrapJulia (callPackage
    (import ./generic.nix {
      version = "1.10.9";
      hash = "sha256-u9by+X76fcXs+w159KTSvw43JeYwJ9Wvn0VyoEfniTM=";
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
    })
    { });
  julia_111 = wrapJulia (callPackage
    (import ./generic.nix {
      version = "1.11.4";
      hash = "sha256-xJNlYtBRKIQtf+K+MHNDM1GeqUpUhhtdC/440QPpa1s=";
      patches = [
        ./patches/1.11/0002-skip-failing-and-flaky-tests.patch
      ];
    })
    { });
}
