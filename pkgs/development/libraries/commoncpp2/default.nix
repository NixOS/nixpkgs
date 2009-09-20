args: with args;
stdenv.mkDerivation {
  name = "commoncpp2-1.7.3";

  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/commoncpp/commoncpp2-1.7.3.tar.gz;
    sha256 = "11akz0gwr4xq5wbgbrb8ixkqmn8pmrwc19b9yw8lydvd3rh5gamk";
  };

  buildInputs = [];

  meta = { 
    description = "highly portable application framework for threading,sockets, realtime network streaming, persistance, and file access";

    homepage = http://sourceforge.net/projects/cplusplus/;
    license = "LGPL";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
