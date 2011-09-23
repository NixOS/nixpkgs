{ fetchurl, buildPerlPackage, bzip2 }:

buildPerlPackage rec {
  name = "Compress-Raw-Bzip2-2.037";
    
  src = fetchurl {
    url = "mirror://cpan/modules/by-module/Compress/${name}.tar.gz";
    sha256 = "0fhl8dh8mhvpqfqm85amv694ybflckqhyli9y18x8viwaddbxqpy";
  };

  # Don't build a private copy of bzip2.
  BUILD_BZIP2 = false;
  BZIP2_LIB = "${bzip2}/lib";
  BZIP2_INCLUDE = "${bzip2}/include";
}
