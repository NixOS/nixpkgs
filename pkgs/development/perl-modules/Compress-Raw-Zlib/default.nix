{ fetchurl, buildPerlPackage, zlib, stdenv }:

buildPerlPackage rec {
  name = "Compress-Raw-Zlib-2.081";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "06rsm9ahp20xfyvd3jc69sd0k8vqysryxc6apzdbn96jbcsdwmp1";
  };

  preConfigure = ''
    cat > config.in <<EOF
      BUILD_ZLIB   = False
      INCLUDE      = ${zlib.dev}/include
      LIB          = ${zlib.out}/lib
      OLD_ZLIB     = False
      GZIP_OS_CODE = AUTO_DETECT
    EOF
  '';

  doCheck = !stdenv.isDarwin;

  meta = {
    license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
  };
}
