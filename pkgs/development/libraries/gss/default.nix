{ fetchurl, stdenv, shishi }:

stdenv.mkDerivation rec {
  name = "gss-1.0.0";

  src = fetchurl {
    url = "mirror://gnu/gss/${name}.tar.gz";
    sha256 = "0rcbzg19m7bddvbhjqv1iwyydkj61czb0xr691mkj0i5p4d4bakk";
  };

  buildInputs = [ shishi ];

  doCheck = true;

  # Work around the lack of `-lshishi' for `krb5context'.  See
  # <http://lists.gnu.org/archive/html/help-gsasl/2010-05/msg00005.html>.
  checkPhase = "make check LDFLAGS=-lshishi";

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
