{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.2";
  branch = "2.7";
  sha256 = "1wlygd0jp34dk4qagi4h9psn4yk8zgyj7zy9lrpm5332mm87bsvw";
})
