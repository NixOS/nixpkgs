{ fetchurl, buildPerlPackage, zlib, stdenv }:

buildPerlPackage rec {
  name = "Compress-Raw-Zlib-2.060";

  src = fetchurl {
    url = "mirror://cpan/modules/by-module/Compress/${name}.tar.gz";
    sha256 = "03z2vqcdpysanqnh9m714fs2mcfshzbkd8i11w359h69h5q0kms3";
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

  meta = {
    license = "perl5";
  };
}
