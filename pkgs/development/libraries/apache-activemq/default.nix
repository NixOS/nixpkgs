{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "apache-activemq-${version}";
  version = "5.14.5";

  src = fetchurl {
    sha256 = "0vm8z7rxb9n10xg5xjahy357704fw3q477hmpb83kd1zrc633g54";
    url = "mirror://apache/activemq/${version}/${name}-bin.tar.gz";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out
    mv * $out/
    for j in `find $out/lib -name "*.jar"`; do
      cp="''${cp:+"$cp:"}$j";
    done
    echo "CLASSPATH=$cp" > $out/lib/classpath.env
  '';

  meta = {
    homepage = http://activemq.apache.org/;
    description = "Messaging and Integration Patterns server written in Java";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };

}
