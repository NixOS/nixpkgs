{ stdenv, fetchurl, curl, libxml2 }:

stdenv.mkDerivation rec {
  name = "xmlrpc-c-1.51.06";

  src = fetchurl {
    url = "mirror://sourceforge/xmlrpc-c/${name}.tgz";
    sha256 = "1l4zz22q10081vr06b8sii0l3krr64xyiywz6rcladw8kiyxip06";
  };

  buildInputs = [ curl libxml2 ];

  configureFlags = [
    "--enable-libxml2-backend"
  ];

  # Build and install the "xmlrpc" tool (like the Debian package)
  postInstall = ''
    (cd tools/xmlrpc && make && make install)
  '';

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "A lightweight RPC library based on XML and HTTP";
    homepage = "http://xmlrpc-c.sourceforge.net/";
    # <xmlrpc-c>/doc/COPYING also lists "Expat license",
    # "ABYSS Web Server License" and "Python 1.5.2 License"
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
