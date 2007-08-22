{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.21";
  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxslt-1.1.21.tar.gz;
    sha256 = "1q2lzdp75lx9w4mxgg99znnk94aacn34m7csmbf2kdwvnb7d9vyc";
  };
  buildInputs = [libxml2];
}
