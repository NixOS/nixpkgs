{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "apache-activemq-${version}";
  version = "5.13.2";

  src = fetchurl {
    sha256 = "0vrgny8fw973xvr3w4wc1s44z50b0c2hgcqa91s8fbx2yjmqn5xy";
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
  };

}
