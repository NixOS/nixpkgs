{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "apache-activemq";
  version = "5.16.1";

  src = fetchurl {
    sha256 = "sha256-Q9PzqJC/+uhcbxAC6c+VD8wf0X8/XlXcO4XTnQni4yM=";
    url = "mirror://apache/activemq/${version}/${pname}-${version}-bin.tar.gz";
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
    homepage = "http://activemq.apache.org/";
    description = "Messaging and Integration Patterns server written in Java";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };

}
