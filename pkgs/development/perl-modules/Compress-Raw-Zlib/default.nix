{ fetchurl, buildPerlPackage, zlib, stdenv }:

buildPerlPackage rec {
  name = "Compress-Raw-Zlib-2.056";

  src = fetchurl {
    url = "mirror://cpan/modules/by-module/Compress/${name}.tar.gz";
    sha256 = "08cbgbrfx718r1n9d8hzmv7ssnhw41b0pwg7fw6dcq3svqhmwkyl";
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

  doCheck = !stdenv.isDarwin;
}
