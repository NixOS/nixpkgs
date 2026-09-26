{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "30.2";
    hash = "sha256-kkQQQPU6wk1/UMRwEMLVIR6JB29Fm6L3OrsvaeI6VAA=";
  }
  // args
)
