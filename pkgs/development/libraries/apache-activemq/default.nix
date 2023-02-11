{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "apache-activemq";
  version = "5.17.3";

  src = fetchurl {
    sha256 = "sha256-pMxMOi8TZwfCxpbzuz7iqG2+/xueteI3sU7cDF5aMo8=";
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
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };

}
