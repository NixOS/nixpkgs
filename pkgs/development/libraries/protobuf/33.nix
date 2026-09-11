{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "33.6";
    hash = "sha256-Uoj1Q5D+ofWFc/GPOgOHgIWVwKrpJrpkHMpL+yU0/k8=";
  }
  // args
)
