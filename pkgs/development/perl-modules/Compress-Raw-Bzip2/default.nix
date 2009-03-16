{fetchurl, buildPerlPackage, bzip2}:

buildPerlPackage rec {
  name = "Compress-Raw-Bzip2-2.015";
    
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "0rc49w7i552j89ws85h7s1bzvs17m065lgy3mj23h0gplkbjnwkp";
  };

  # Don't build a private copy of bzip2.
  BUILD_BZIP2 = false;
  BZIP2_LIB = "${bzip2}/lib";
  BZIP2_INCLUDE = "${bzip2}/include";
}
