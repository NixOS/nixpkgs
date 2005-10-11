{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.4.2";
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/aterm/aterm-2.4.2.tar.gz;
    md5 = "18617081dd112d85e6c4b1b552628114";
  };
}
