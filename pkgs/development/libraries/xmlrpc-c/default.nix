{ lib, stdenv, fetchurl, curl, libxml2 }:

stdenv.mkDerivation rec {
  pname = "xmlrpc-c";
  version = "1.51.07";

  src = fetchurl {
    url = "mirror://sourceforge/xmlrpc-c/${pname}-${version}.tgz";
    sha256 = "sha256-hNIK4z+SdYL4IdYcC5GUrvvx15JFkKE/qdpa4WmK3tk=";
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

  meta = with lib; {
    description = "Lightweight RPC library based on XML and HTTP";
    homepage = "https://xmlrpc-c.sourceforge.net/";
    # <xmlrpc-c>/doc/COPYING also lists "Expat license",
    # "ABYSS Web Server License" and "Python 1.5.2 License"
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
