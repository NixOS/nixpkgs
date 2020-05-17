{ callPackage
, doCheck ? true
}:
let
  resholve = callPackage ./resholve.nix { inherit doCheck; };
  resholvePackage =
    callPackage ./resholve-package.nix { inherit resholve; };

in
{
  inherit resholve;
  inherit resholvePackage;
}
