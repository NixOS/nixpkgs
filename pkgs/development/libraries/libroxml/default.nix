{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "libroxml-2.3.0";
  src = fetchurl {
    url = "http://download.libroxml.net/pool/v2.x/libroxml-2.3.0.tar.gz";
    sha256  = "0y0vc9n4rfbimjp28nx4kdfzz08j5xymh5xjy84l9fhfac5z5a0x";
  };
  meta = with stdenv.lib; {
    homepage = http://www.libroxml.net/;
    description = "This library is minimum, easy-to-use, C implementation for xml file parsing.";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mpickering ];
  };
}
