{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "apache-activemq-${version}";
  version = "5.8.0";

  src = fetchurl {
    url = "mirror://apache/activemq/apache-activemq/${version}/${name}-bin.tar.gz";
    sha256 = "12a1lmmqapviqdgw307jm07vw1z5q53r56pkbp85w9wnqwspjrbk";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    ensureDir $out
    mv LICENSE lib $out/
    for j in `find $out/lib -name "*.jar"`; do
      cp="''${cp:+"$cp:"}$j";
    done
    echo "CLASSPATH=$cp" > $out/lib/classpath.env
  '';

  meta = {
    homepage = http://activemq.apache.org/;
    description = ''
      Messaging and Integration Patterns server written in Java.
      This nixpkg supplies the jar-files packaged in activemq's
      binary distribution.
    '';
    license = stdenv.lib.licenses.asl20;
  };

}
