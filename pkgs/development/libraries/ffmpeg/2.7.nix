{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.1";
  branch = "2.7";
  sha256 = "087pyx1wxvniq3wgj6z80wrb7ampwwsmwndmr7lymzhm4iyvj1vy";
})
