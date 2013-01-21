{ fetchurl, buildPerlPackage, bzip2 }:

buildPerlPackage rec {
  name = "Compress-Raw-Bzip2-2.060";

  src = fetchurl {
    url = "mirror://cpan/modules/by-module/Compress/${name}.tar.gz";
    sha256 = "02azwhglk2w68aa47sjqhj6vwzi66mv4hwal87jccjfy17gcwvx7";
  };

  # Don't build a private copy of bzip2.
  BUILD_BZIP2 = false;
  BZIP2_LIB = "${bzip2}/lib";
  BZIP2_INCLUDE = "${bzip2}/include";
}
