{ fetchurl, buildPerlPackage, zlib }:

buildPerlPackage rec {
  name = "Compress-Raw-Zlib-2.037";
    
  src = fetchurl {
    url = "mirror://cpan/modules/by-module/Compress/${name}.tar.gz";
    sha256 = "18grvxjlsqlqiwxgdf26s4z4q9ag0vacrswxbyaqf11a03sciw7d";
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
