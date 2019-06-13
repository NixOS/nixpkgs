{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "1bcji95n1iz9p9vsgdgr26v6s7zhpsxfbjjwpqcihpfd6lawyhgr";
  };
})
