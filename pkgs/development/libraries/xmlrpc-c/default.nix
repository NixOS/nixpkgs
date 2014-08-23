{ stdenv, fetchurl, curl }:

stdenv.mkDerivation rec {
  name = "xmlrpc-c-1.25.27";

  src = fetchurl {
    url = "mirror://sourceforge/xmlrpc-c/${name}.tgz";
    sha256 = "0g9m9n258lpbs42a2lagd4h7qim1g34gkaqyx8h50qrsk49ipspn";
  };

  buildInputs = [ curl ];

  # Build and install the "xmlrpc" tool (like the Debian package)
  postInstall = ''
    (cd tools/xmlrpc && make && make install)
  '';

  meta = with stdenv.lib; {
    description = "A lightweight RPC library based on XML and HTTP";
    homepage = http://xmlrpc-c.sourceforge.net/;
    # <xmlrpc-c>/doc/COPYING also lists "Expat license",
    # "ABYSS Web Server License" and "Python 1.5.2 License"
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
