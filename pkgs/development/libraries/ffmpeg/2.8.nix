{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.11";
  branch = "2.8";
  sha256 = "0cldkzcbvsnb7mxz3kwpa0mnb44wmlc0qyl01wwi2qznn7vf11wr";
})
