{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "25.5";
    hash = "sha256-DFLlk4T8ODo3lmvrANlkIsrmDXZHmqMPTYxDWaz56qA=";
  }
  // args
)
