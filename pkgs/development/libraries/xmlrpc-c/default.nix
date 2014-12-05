{ stdenv, fetchurl, curl }:

stdenv.mkDerivation rec {
  name = "xmlrpc-c-1.25.30";

  src = fetchurl {
    url = "mirror://sourceforge/xmlrpc-c/${name}.tgz";
    sha256 = "161gj237baagy5jaa08m54zfyvilb19gql0i5c9ysl3xqm7fvrla";
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
