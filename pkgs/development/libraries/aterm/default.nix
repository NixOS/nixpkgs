{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.1";
  configureFlags = "--with-gcc";
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/aterm/aterm-2.1.tar.gz;
    md5 = "b9d541da35b6d287af1cd8460963a7a8";
  };
}
