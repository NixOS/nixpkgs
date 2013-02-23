{ fetchurl, stdenv, gss, libidn }:

stdenv.mkDerivation rec {
  name = "gsasl-1.8.0";

  src = fetchurl {
    url = "mirror://gnu/gsasl/${name}.tar.gz";
    sha256 = "1rci64cxvcfr8xcjpqc4inpfq7aw4snnsbf5xz7d30nhvv8n40ii";
  };

  buildInputs = [ gss libidn ];

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

    maintainers = with stdenv.lib.maintainers; [ bjg ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
