{ fetchurl, stdenv, gss, libidn, krb5Full }:

stdenv.mkDerivation rec {
  name = "gsasl-1.8.0";

  src = fetchurl {
    url = "mirror://gnu/gsasl/${name}.tar.gz";
    sha256 = "1rci64cxvcfr8xcjpqc4inpfq7aw4snnsbf5xz7d30nhvv8n40ii";
  };

  buildInputs = [ libidn ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) gss
    ++ stdenv.lib.optional stdenv.isDarwin krb5Full;

  configureFlags = stdenv.lib.optionalString stdenv.isDarwin "--with-gssapi-impl=mit";

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
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
