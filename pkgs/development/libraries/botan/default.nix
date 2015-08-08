{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.10";
  revision = "10";
  sha256 = "0qs1ps25k79jnzm31zjl6hj8kxzfwwjsdrlc9bz621218r3v2rvb";
  extraConfigureFlags = "--with-gnump";
})
