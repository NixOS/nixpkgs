{fetchurl, buildPerlPackage, zlib}:

buildPerlPackage rec {
  name = "Compress-Raw-Zlib-2.015";
    
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "0g6kz73jxqjfln2pi500y7rr96mhad16hrp5wy6542fapamv4xcd";
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
