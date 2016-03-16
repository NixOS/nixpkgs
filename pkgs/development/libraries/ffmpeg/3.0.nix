{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.0";
  sha256 = "1h0k05cj6j0nd2i16z7hc5scpwsbg3sfx68lvm0nlwvz5xxgg7zi";
})
