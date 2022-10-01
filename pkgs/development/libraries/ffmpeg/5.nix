{ callPackage, ... }@args:

callPackage ./generic.nix (rec {
  version = "5.1.2";
  branch = version;
  sha256 = "sha256-OaC8yNmFSfFsVwYkZ4JGpqxzbAZs69tAn5UC6RWyLys=";
} // args)
