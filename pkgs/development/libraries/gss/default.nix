{ fetchurl, stdenv, shishi }:

stdenv.mkDerivation rec {
  name = "gss-1.0.2";

  src = fetchurl {
    url = "mirror://gnu/gss/${name}.tar.gz";
    sha256 = "1qa8lbkzi6ilfggx7mchfzjnchvhwi68rck3jf9j4425ncz7zsd9";
  };

  buildInputs = [ shishi ];

  doCheck = true;

  meta = {
    description = "GNU GSS Generic Security Service";

    longDescription =
      '' GSS is an implementation of the Generic Security Service Application
	 Program Interface (GSS-API). GSS-API is used by network servers to
	 provide security services, e.g., to authenticate SMTP/IMAP clients
	 against SMTP/IMAP servers.
       '';

    homepage = http://www.gnu.org/software/gss/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
