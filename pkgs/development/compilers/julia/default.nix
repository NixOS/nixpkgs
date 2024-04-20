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
      version = "1.10.2";
      sha256 = {
        x86_64-linux = "51bccc9bb245197f24e6b2394e6aa69c0dc1e41b4e300b796e17da34ef64db1e";
        aarch64-linux = "f319ff2812bece0918cb9ea6e0df54cc9412fc5ef8c0589b6a4fea485c07535d";
        x86_64-darwin = "52679b9285b9aa8354afade8cc5a6c98d30af31ee72e4e879d17cef5dd4d4213";
        aarch64-darwin = "c7392237725b54d2d145bf56ce362e502596ea4338523a91bf20ce02379cea80";
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
      version = "1.10.2";
      hash = "sha256-YkaHIK+8QQ608mLtJDOpITJieHLJ9pC3BNwEXMsVVAE=";
      patches = [
        ./patches/1.10/0001-skip-building-docs-as-it-requires-network-access.patch
        ./patches/1.10/0002-skip-failing-and-flaky-tests.patch
      ];
    })
    { });
}
