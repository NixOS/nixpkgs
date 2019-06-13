{ fetchurl, buildPerlPackage, zlib, stdenv }:

buildPerlPackage rec {
  name = "Compress-Raw-Zlib-2.086";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "0va93wc968p4l2ql0k349bz189l2vbs09bpn865cvc36amqxwv9z";
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
