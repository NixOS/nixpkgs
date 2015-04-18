{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.0";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "04yrpjz33vrj6j0zxc153b00f93i8hs41syr1ryp7sr64fyw0lcn";
  };
})
