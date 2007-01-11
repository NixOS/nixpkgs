{stdenv, fetchurl, openssl}:

stdenv.mkDerivation {
  name = "openldap-2.3.32";
  src = fetchurl {
    url = ftp://ftp.nl.uu.net/pub/unix/db/openldap/openldap-release/openldap-2.3.32.tgz;
    md5 = "154d674cf95a8f8acc496cc6cb0671e1";
  };
  buildInputs = [openssl];
  configureFlags = "--disable-slapd --disable-static";
  dontPatchELF = 1; # !!!
}
