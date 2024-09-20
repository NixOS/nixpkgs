{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.11.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/celt/celt-${version}.tar.gz";
    sha256 = "0dh893wqbh0q4a0x1xyqryykmnhpv7mkblpch019s04a99fq2r3y";
  };
})
