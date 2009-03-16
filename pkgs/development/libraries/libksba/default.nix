args: with args;

stdenv.mkDerivation rec {
  name = "libksba-1.0.2";

  src = fetchurl {
    url = "ftp://ftp.gnupg.org/gcrypt/libksba/${name}.tar.bz2";
    sha256 = "1jkjh1daaykkrfq0s4vv8ddf0w8agdvspg9qm0ghjidlrfnsfiwh";
  };

  propagatedBuildInputs = [libgpgerror];

  configureFlags = "--enable-shared --disable-static";

  meta = {
    homepage = http://www.gnupg.org;
    description = "Libksba is a CMS and X.509 access library under development";
  };
}
