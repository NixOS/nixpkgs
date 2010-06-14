{ fetchurl, stdenv, shishi }:

stdenv.mkDerivation rec {
  name = "gss-1.0.1";

  src = fetchurl {
    url = "mirror://gnu/gss/${name}.tar.gz";
    sha256 = "05g9p45gmd0332ly19g13rbi0wdx447imw42f22482rdr8vpy9m0";
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
