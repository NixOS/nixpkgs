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
      version = "1.10.7";
      sha256 = {
        x86_64-linux = "21b2c69806aacf191d7c81806c7d9918bddab30c7b5b8d4251389c3abe274334";
        aarch64-linux = "93bf1b113f297c817310f77d1edce4ab9dcbf49432489cb8df09afbf93d1e5a0";
        x86_64-darwin = "4643d1052ed478b646be06f545b50698fbc572b216dcca3bca69f429ce0e1321";
        aarch64-darwin = "8beb61a29a6c32e26f55070dba8ded37f8572ad07aebd461a06ff5b10d48dc36";
      };
    })
    { });
  julia_111-bin = wrapJulia (callPackage
    (import ./generic-bin.nix {
      version = "1.11.3";
      sha256 = {
        x86_64-linux = "7d48da416c8cb45582a1285d60127ee31ef7092ded3ec594a9f2cf58431c07fd";
        aarch64-linux = "0c1f2f60c3ecc37ae0c559db325dc64858fb11d6729b25d63f23e5285f7906ef";
        x86_64-darwin = "5220aade1b43db722fb4e287f1c5d25aa492267b86a846db1546504836cca1be";
        aarch64-darwin = "554fb0ddb4d94d623c83ca5e9d309fe1a7a0924445cb18ec3b863fb3367b0ba8";
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
      version = "1.10.7";
      hash = "sha256-BLo4KQstKnowOcMlHXClRRxP5ZXmTpl4rl7D+q+Fajw=";
      patches = [
        ./patches/1.10/0002-skip-failing-and-flaky-tests.patch
      ];
    })
    { });
  julia_111 = wrapJulia (callPackage
    (import ./generic.nix {
      version = "1.11.3";
      hash = "sha256-Ansli0e04agdHs3TVa3v/bbAGBya2YjnF/XkdaEqHeg=";
      patches = [
        ./patches/1.11/0002-skip-failing-and-flaky-tests.patch
      ];
    })
    { });
}
