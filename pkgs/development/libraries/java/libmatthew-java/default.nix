{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {
  name = "libmatthew-java-0.8";
  src = fetchurl {
    url = https://src.fedoraproject.org/repo/pkgs/libmatthew-java/libmatthew-java-0.8.tar.gz/8455b8751083ce25c99c2840609271f5/libmatthew-java-0.8.tar.gz;
    sha256 = "1yldkhsdzm0a41a0i881bin2jklhp85y3ah245jd6fz3npcx7l85";
  };
  JAVA_HOME=jdk;
  PREFIX=''''${out}'';
  buildInputs = [ jdk ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.sander ];
    license = licenses.mit;
  };
}
