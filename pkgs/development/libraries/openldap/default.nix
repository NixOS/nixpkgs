args: with args;

stdenv.mkDerivation {
  name = "openldap-2.3.32";
  src = fetchurl {
    url = ftp://ftp.nl.uu.net/pub/unix/db/openldap/openldap-release/openldap-2.3.32.tgz;
    sha256 = "1pw6j8ag8nm91mccwb3p9wk7ccsfdb8jz5v6a5alfrq3npyck0j8";
  };
  buildInputs = [openssl cyrus_sasl db4];
  configureFlags = "--disable-static";
  dontPatchELF = 1; # !!!
}
