{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "apache-activemq";
  version = "5.16.0";

  src = fetchurl {
    sha256 = "0x68l4n0v2jqmbawdgpghmhnchpg1jsvxzskj6s4hjll6hdgb6fk";
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
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };

}
