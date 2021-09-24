{ callPackage
, ...
}:

let
  source = callPackage ./source.nix { };
  deps = callPackage ./deps.nix { };
in
rec {
  resholve = callPackage ./resholve.nix {
    inherit (source) rSrc;
    inherit (source) version;
    inherit (deps.oil) oildev;
  };
  resholvePackage = callPackage ./resholve-package.nix {
    inherit resholve;
  };
}
