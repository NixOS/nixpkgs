{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "apache-activemq";
  version = "5.15.12";

  src = fetchurl {
    sha256 = "14v117r9zqvrqr79h66r0dm9lyxq3104rcdizcnvk0syz0zbwps1";
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
