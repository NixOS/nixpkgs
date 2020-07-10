{ callPackage, ... } @ args:

callPackage ./generic.nix (rec {
  version = "${branch}.16";
  branch = "2.8";
  sha256 = "0lfmfd6rhywis9rblkxv33rpwfga9xv261fq4cn3pkx1izih7ybk";
} // args)
