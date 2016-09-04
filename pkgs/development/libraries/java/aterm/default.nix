{stdenv, fetchurl, jdk, sharedobjects, jjtraveler}:

stdenv.mkDerivation {
  name = "aterm-java-1.6";
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/aterm-java/aterm-java-1.6.tar.gz;
    md5 = "abf475dae2f5efca865fcdff871feb5e";
  };
  buildInputs = [stdenv jdk sharedobjects jjtraveler];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
