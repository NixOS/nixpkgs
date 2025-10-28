{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "33.0";
    hash = "sha256-VoMMMyPGAyjhXrYw7muHFBRjYshfqgLZZPPOXCfmmPs=";
  }
  // args
)
