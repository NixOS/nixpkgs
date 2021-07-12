{ callPackage
, doCheck ? true
}:

rec {
  resholve = callPackage ./resholve.nix { inherit doCheck; };
  resholvePackage =
    callPackage ./resholve-package.nix { inherit resholve; };
}
