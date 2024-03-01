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
      version = "1.10.0";
      sha256 = {
        x86_64-linux = "a7298207f72f2b27b2ab1ce392a6ea37afbd1fbee0f1f8d190b054dcaba878fe";
        aarch64-linux = "048d96b4398efd524e94be3f49e8829cf6b30c8f3f4b46c75751a4679635e45b";
        x86_64-darwin = "eb1cdf2d373ee40412e8f5ee6b4681916f1ead6d794883903619c7bf147d4f46";
        aarch64-darwin = "dc4ca01b1294c02d47b33ef26d489dc288ac68655a03774870c6872b82a9a7d6";
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
      version = "1.10.0";
      hash = "sha256-pfjAzgjPEyvdkZygtbOytmyJ4OX35/sqgf+n8iXj20w=";
      patches = [
        ./patches/1.10/0001-skip-building-docs-as-it-requires-network-access.patch
        ./patches/1.10/0002-skip-failing-and-flaky-tests.patch
      ];
    })
    { });
}
