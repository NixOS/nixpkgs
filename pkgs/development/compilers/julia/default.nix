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
      version = "1.10.5";
      sha256 = {
        x86_64-linux = "33497b93cf9dd65e8431024fd1db19cbfbe30bd796775a59d53e2df9a8de6dc0";
        aarch64-linux = "59620a93cd64542d1f901ef9cfaecd310d0673b2bab2e2345774d456952a7ad0";
        x86_64-darwin = "fb2754d6038c54abc8c04aff6dfe5b51987a6834d4a7a4658130f59e36d9b403";
        aarch64-darwin = "d503d720169e58dd60244063831a6f7bc72a345529a9622f6dc9f3825b0b9ab6";
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
      version = "1.10.5";
      hash = "sha256-X8lBWbh/NNGL9EoalA5Z9Ay+q5Mb/cDEdjIDu7aZUmA=";
      patches = [
        ./patches/1.10/0002-skip-failing-and-flaky-tests.patch
      ];
    })
    { });
}
