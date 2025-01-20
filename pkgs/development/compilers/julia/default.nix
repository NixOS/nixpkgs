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
      version = "1.11.2";
      sha256 = {
        x86_64-linux = "8a372ad262d4d4d55a1044f4fe3bce7c9a4a3ce8c513d2470e58e8071eecd476";
        aarch64-linux = "0346e6d65852a3b73ced2c80c40f5a8cf38e7048d001cd57d3d1dd9efb2f6641";
        x86_64-darwin = "0b52ba3d7f283e43ba853bc3d0f401decf993d8d53da752bd644a9f934679184";
        aarch64-darwin = "bcfe9c788f3dcf613a4753a4d9771d8381d00caf0e8af64d8aa87af10068b754";
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
      version = "1.11.2";
      hash = "sha256-pzZblplE8n3w2FY3FsqXaeB/P3e5+fu0i80RTd91LKQ=";
      patches = [
        ./patches/1.11/0002-skip-failing-and-flaky-tests.patch
      ];
    })
    { });
}
