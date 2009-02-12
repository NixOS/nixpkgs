{stdenv, fetchurl, openssl, cyrus_sasl, db4, groff}:

stdenv.mkDerivation {
  name = "openldap-2.4.13";
  
  src = fetchurl {
    url = ftp://ftp.nl.uu.net/pub/unix/db/openldap/openldap-release/openldap-2.4.13.tgz;
    sha256 = "18l06v8z5wnr92m28bwxd27l6kw3i0gi00yivv603da6m76cm0ic";
  };
  
  buildInputs = [openssl cyrus_sasl db4 groff];
  
  configureFlags = "--disable-static";

  dontPatchELF = 1; # !!!

  # Build on Glibc 2.9.
  # http://www.openldap.org/lists/openldap-bugs/200808/msg00130.html
  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  meta = {
    homepage = http://www.openldap.org/;
    description = "An open source implementation of the Lightweight Directory Access Protocol";
  };
}
