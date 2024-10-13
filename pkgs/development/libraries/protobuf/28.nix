{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "28.2";
    hash = "sha256-+ogjfmsbPUhqETJyHxoc1gYW/7a/JMc5l1gb/7WDqLE=";
  }
  // args
)
