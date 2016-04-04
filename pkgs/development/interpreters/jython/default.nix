{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "jython-${version}";

  version = "2.7.0";

  src = fetchurl {
    url = "http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/${version}/jython-standalone-${version}.jar";
    sha256 = "0sk4myh9v7ma7nmzb8khg41na77xfi2zck7876bs7kq18n8nc1nx";
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
