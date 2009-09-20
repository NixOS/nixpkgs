args: with args;
stdenv.mkDerivation {
  name = "libzrtpcpp-1.4.1.tar";

  src = fetchurl {
    url = mirror://gnu/ccrtp/libzrtpcpp-1.4.1.tar.gz;
    sha256 = "0gj5xiv15xnxdbppa06fy02j8jg0zm1capva4nhbpgzg08n7p8y0";
  };

  buildInputs = [commoncpp2 openssl pkgconfig ccrtp];

  meta = { 
    description = "GNU RTP stack for the zrtp protocol developed by Phil Zimmermann";
    homepage = "http://www.gnutelephony.org/index.php/GNU_ZRTP";
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
