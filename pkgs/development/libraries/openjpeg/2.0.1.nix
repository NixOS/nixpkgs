{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.0.1";
  branch = "2";
  src = fetchurl {
    url = "mirror://sourceforge/openjpeg.mirror/openjpeg-${version}.tar.gz";
    sha256 = "1c2xc3nl2mg511b63rk7hrckmy14681p1m44mzw3n1fyqnjm0b0z";
  };
})
