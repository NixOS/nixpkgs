{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "gsasl-1.4.4";

  src = fetchurl {
    url = "mirror://gnu/gsasl/${name}.tar.gz";
    sha256 = "0xd9irff42dd5i4cr74dy0yd9ijjv9nkg6c2l1328grsn8zifwdc";
  };

  doCheck = true;

  meta = {
    description = "GNU SASL, Simple Authentication and Security Layer library";

    longDescription =
      '' GNU SASL is a library that implements the IETF Simple 
         Authentication and Security Layer (SASL) framework and 
         some SASL mechanisms. SASL is used in network servers 
         (e.g. IMAP, SMTP, etc.) to authenticate peers. 
       '';

    homepage = http://www.gnu.org/software/gsasl/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
