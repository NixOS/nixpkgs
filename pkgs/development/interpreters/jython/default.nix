{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "jython-${version}";

  version = "2.7.1";

  src = fetchurl {
    url = "http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/${version}/jython-standalone-${version}.jar";
    sha256 = "0jwc4ly75cna78blnisv4q8nfcn5s0g4wk7jf4d16j0rfcd0shf4";
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
