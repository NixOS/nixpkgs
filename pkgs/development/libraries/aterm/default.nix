{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.2";
  configureFlags = "--with-gcc";
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/aterm/aterm-2.2.tar.gz;
    md5 = "e1098f4cb84dbfce095cb4c14303ec16";
  };
}
