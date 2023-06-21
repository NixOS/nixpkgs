{ callPackage, ... }@args:

callPackage ./generic.nix (rec {
  version = "5.1.3";
  branch = version;
  sha256 = "sha256-XVvvahHwxQBYj5hw7JZaMKzA1U2LHlNdplVKMpAtI20=";
} // args)

