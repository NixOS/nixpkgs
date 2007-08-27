{stdenv, fetchurl, m4}:

stdenv.mkDerivation {
  name = "beecrypt-4.1.2";
  src = fetchurl {
    url = mirror://sourceforge/beecrypt/beecrypt-4.1.2.tar.gz;
    md5 = "820d26437843ab0a6a8a5151a73a657c";
  };
  buildInputs = [m4];
  configureFlags = "--disable-optimized --enable-static";
}
