{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "29.4";
    hash = "sha256-02MeQ8+1dqQI1B3szkdsz3dts3YmtwXK7gkriUtBEbU=";
  }
  // args
)
