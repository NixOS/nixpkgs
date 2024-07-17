{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "apache-activemq";
  version = "6.1.2";

  src = fetchurl {
    sha256 = "sha256-EJZWrGvXICxp+eDzrX5BPnl/ZuUMO7utKgaS2c4IBQ0=";
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
