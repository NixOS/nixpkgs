{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.3.1";
  configureFlags = "--with-gcc";

  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/aterm/aterm-2.3.1.tar.gz;
    md5 = "5a2d70acc45a9d301e0dba12fcaf77e7";
  };
}
