{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "jython";

  version = "2.7.2b3";

  src = fetchurl {
    url = "http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/${version}/jython-standalone-${version}.jar";
    sha256 = "142285hd9mx0nx5zw0jvkpqkb4kbhgyyy52p5bj061ya8bg5jizy";
  };

  buildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
     mkdir -pv $out/bin
     cp $src $out/jython.jar
     makeWrapper ${jre}/bin/java $out/bin/jython --add-flags "-jar $out/jython.jar"
  '';

  meta = {
    description = "Python interpreter written in Java";
    homepage = "https://jython.org/";
    license = stdenv.lib.licenses.psfl;
    platforms = jre.meta.platforms;
  };
}
