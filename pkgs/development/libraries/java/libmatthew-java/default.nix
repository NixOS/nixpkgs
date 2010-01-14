{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {
  name = "libmatthew-java-0.7.2";
  src = fetchurl {
    url = http://www.matthew.ath.cx/projects/java/libmatthew-java-0.7.2.tar.gz;
    sha256 = "00zd6vplbvha64pf65bpw44abg2y8irblik30pbk35wcm86a0j4z";
  };
  JAVA_HOME=jdk;
  PREFIX=''''${out}'';
  buildInputs = [ jdk ];
  maintainers = [ stdenv.lib.maintainers.sander ];
}
