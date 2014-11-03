{ stdenv, fetchurl, commoncpp2, openssl, pkgconfig, ccrtp }:

stdenv.mkDerivation rec {
  name = "libzrtpcpp-1.6.0";

  src = fetchurl {
    url = "mirror://gnu/ccrtp/${name}.tar.gz";
    sha256 = "17aayr4f27rp4fvminxn6jx7kq56kkk341l7ypqb9h0k6kns27kb";
  };

  buildInputs = [ commoncpp2 openssl pkgconfig ccrtp ];

  meta = { 
    description = "GNU RTP stack for the zrtp protocol developed by Phil Zimmermann";
    homepage = "http://www.gnutelephony.org/index.php/GNU_ZRTP";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
