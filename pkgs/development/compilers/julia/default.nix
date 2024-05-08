{ callPackage }:

let
  juliaWithPackages = callPackage ../../julia-modules { };

  wrapJulia = julia: julia.overrideAttrs (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      withPackages = juliaWithPackages.override { inherit julia; };
    };
  });

in

{
  julia_16-bin = wrapJulia (callPackage ./1.6-bin.nix { });
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
      version = "1.10.3";
      sha256 = {
        x86_64-linux = "81b910c922fff0e27ae1f256f2cc803db81f3960215281eddd2d484721928c70";
        aarch64-linux = "2d52a61826872b3170c65f99a954bd9d21a31211cb50948056d924f811a0024f";
        x86_64-darwin = "af61600db0abdc56fffb1b47cd18c30213b8925796546b53b657e164126082b4";
        aarch64-darwin = "9ea32daa1bef34c8e48d6c76187f48fd2bf1054cc921fb8c374b737b51c9ffdd";
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
      version = "1.10.3";
      hash = "sha256-2JKyEjvmTaz50F5My61/F5f2v4fDl6dIBLARyHUPbI8=";
      patches = [
        ./patches/1.10/0001-skip-building-docs-as-it-requires-network-access.patch
        ./patches/1.10/0002-skip-failing-and-flaky-tests.patch
      ];
    })
    { });
}
