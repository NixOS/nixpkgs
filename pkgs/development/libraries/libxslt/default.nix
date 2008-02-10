args: with args;

stdenv.mkDerivation {
  name = "libxslt-1.1.22";
  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxslt-1.1.22.tar.gz;
    sha256 = "1nj9pvn4ibhwxpl3ry9n6d7jahppcnqc7mi87nld4vsr2vp3j7sf";
  };
  propagatedBuildInputs = [libxml2];
  configureFlags = "--enable-shared --disable-static";
}
