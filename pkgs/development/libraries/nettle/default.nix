{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "07mif3af077763vc35s1x8vzhzlgqcgxh67c1xr13jnhslkjd526";
  };
})
