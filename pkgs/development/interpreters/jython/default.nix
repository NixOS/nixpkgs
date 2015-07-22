{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "jython-${version}";

  version = "2.7-rc3";

  src = fetchurl {
    url = "http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/${version}/jython-standalone-${version}.jar";
    sha256 = "89fcaf53f1bda6124f836065c1e318e2e853d5a9a1fbf0e96a387c6d38828c78";
  };

  buildInputs = [ makeWrapper ];

  unpackPhase = ":";

  installPhase = ''
     mkdir -pv $out/bin
     cp $src $out/jython.jar
     makeWrapper ${jre}/bin/java $out/bin/jython --add-flags "-jar $out/jython.jar"
  '';

  meta = {
    description = "Python interpreter written in Java";
    homepage = http://jython.org/;
    license = stdenv.lib.licenses.psfl;
    platforms = jre.meta.platforms;
  };
}
