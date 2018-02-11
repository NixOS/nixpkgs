{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {
  name = "libmatthew-java-0.8";
  src = fetchurl {
    url = http://src.fedoraproject.org/repo/pkgs/libmatthew-java/libmatthew-java-0.8.tar.gz/8455b8751083ce25c99c2840609271f5/libmatthew-java-0.8.tar.gz;
    sha256 = "1yldkhsdzm0a41a0i881bin2jklhp85y3ah245jd6fz3npcx7l85";
  };
  JAVA_HOME=jdk;
  PREFIX=''''${out}'';
  buildInputs = [ jdk ];
  maintainers = [ stdenv.lib.maintainers.sander ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
