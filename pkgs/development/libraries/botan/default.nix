{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.10";
  revision = "9";
  sha256 = "1wldp9py3qcdgswgxya83c03y6345a6cf3vwz0y41bl1l39jfza8";
})
