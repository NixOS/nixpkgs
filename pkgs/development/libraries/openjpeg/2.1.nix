{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.0";
  branch = "2.1";
  src = fetchurl {
    url = "mirror://gentoo/distfiles/openjpeg-${version}.tar.gz";
    sha256 = "00zzm303zvv4ijzancrsb1cqbph3pgz0nky92k9qx3fq9y0vnchj";
  };
})
