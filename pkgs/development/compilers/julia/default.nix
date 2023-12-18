{ callPackage }:

let
  juliaWithPackages = callPackage ../../julia-modules {};

  wrapJulia = julia: julia.overrideAttrs (oldAttrs: {
    passthru = (oldAttrs.passthru or {}) // {
      withPackages = juliaWithPackages.override { inherit julia; };
    };
  });

in

{
  julia_16-bin = wrapJulia (callPackage ./1.6-bin.nix {});
  julia_18-bin = wrapJulia (callPackage ./1.8-bin.nix {});
  julia_19-bin = wrapJulia (callPackage ./1.9-bin.nix {});
  julia_18 = wrapJulia (callPackage ./1.8.nix {});
  julia_19 = wrapJulia (callPackage ./1.9.nix {});
}
