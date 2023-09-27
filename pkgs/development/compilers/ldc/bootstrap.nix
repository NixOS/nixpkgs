{ callPackage }:
callPackage ./binary.nix {
  version = "1.30.0";
  hashes = {
    # Get these from `nix store prefetch-file https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc2-1.19.0-osx-x86_64.tar.xz` etc..
    osx-x86_64 = "sha256-AAWZvxuZC82xvrW6fpYm783TY+H8k3DvqE94ZF1yjmk=";
    linux-x86_64 = "sha256-V4TUzEfQhFrwiX07dHOgjdAoGkzausCkhnQIQNAU/eE=";
    linux-aarch64 = "sha256-kTeglub75iv/jWWNPCn15aCGAbmck0RQl6L7bFOUu7Y=";
    osx-arm64 = "sha256-Nb/owBdIeroB9jLMDvwjo8bvsTC9vFyJPLMTOMsSAd4=";
  };
}
