{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "jython";

  version = "2.7.2b2";

  src = fetchurl {
    url = "http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/${version}/jython-standalone-${version}.jar";
    sha256 = "0mmrrydr94q2siwjynkw1gw677navmcvjvbi1jpdbp6idfx0jh6b";
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
    homepage = https://jython.org/;
    license = stdenv.lib.licenses.psfl;
    platforms = jre.meta.platforms;
  };
}
