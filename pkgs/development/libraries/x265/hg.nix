{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "hg-${rev}";
  rev = "eebb372eec893efc50e66806fcc19b1c1bd89683";
  sha256 = "03dpbjqcmbmyid45560byabybfzy2bvic0gqa6k6hxci6rvmynpi";
})