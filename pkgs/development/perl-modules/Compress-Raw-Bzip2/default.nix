{ fetchurl, buildPerlPackage, bzip2 }:

buildPerlPackage rec {
  name = "Compress-Raw-Bzip2-2.055";

  src = fetchurl {
    url = "mirror://cpan/modules/by-module/Compress/${name}.tar.gz";
    sha256 = "1qssagii3xy87lsnlq5y7cngasiiq7jmbi1s6lcwwfhv36ydlmx8";
  };

  # Don't build a private copy of bzip2.
  BUILD_BZIP2 = false;
  BZIP2_LIB = "${bzip2}/lib";
  BZIP2_INCLUDE = "${bzip2}/include";
}
