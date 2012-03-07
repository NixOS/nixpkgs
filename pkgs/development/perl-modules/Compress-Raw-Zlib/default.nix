{ fetchurl, buildPerlPackage, zlib }:

buildPerlPackage rec {
  name = "Compress-Raw-Zlib-2.051";

  src = fetchurl {
    url = "mirror://cpan/modules/by-module/Compress/${name}.tar.gz";
    sha256 = "16c7e0d2ed339c0b5ffe787bbcc9fc063ce6f2145d8cd6a18d0c79fa68d36c09";
  };

  preConfigure = ''
    cat > config.in <<EOF
      BUILD_ZLIB   = False
      INCLUDE      = ${zlib}/include
      LIB          = ${zlib}/lib
      OLD_ZLIB     = False
      GZIP_OS_CODE = AUTO_DETECT
    EOF
  '';
}
