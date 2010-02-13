args: with args;
stdenv.mkDerivation {
  name = "commoncpp2-2.0.8";

  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/commoncpp/ucommon-2.0.8.tar.gz;
    sha256 = "09mk70kqwr1pmxa35x0is16g2sa60b3z8p4p5yccw59pp1hpxpq3";
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
