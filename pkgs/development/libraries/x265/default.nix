{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.5";
  rev = "9f0324125f53a12f766f6ed6f98f16e2f42337f4";
  sha256 = "1nyim0l975faj7926s4wba8yvjy4rvx005zb7krv0gb5p84nzgi7";
})