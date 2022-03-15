{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "apache-activemq";
  version = "5.17.0";

  src = fetchurl {
    sha256 = "sha256-6war1/Re+tQvT1a2cf7n3/TMrDh+B2Wx0lbhm+pm+Jc=";
    url = "mirror://apache/activemq/${version}/${pname}-${version}-bin.tar.gz";
  };

  installPhase = ''
    mkdir -p $out
    mv * $out/
    for j in `find $out/lib -name "*.jar"`; do
      cp="''${cp:+"$cp:"}$j";
    done
    echo "CLASSPATH=$cp" > $out/lib/classpath.env
  '';

  meta = {
    homepage = "https://activemq.apache.org/";
    description = "Messaging and Integration Patterns server written in Java";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };

}
