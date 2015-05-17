{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.2";
  branch = "2.6";
  sha256 = "1fi93zy98wmls7x3jpr2yvckk2ia6a1yyygwrfaxq95pd6h3m7l8";
})
