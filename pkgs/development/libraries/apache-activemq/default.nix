{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "apache-activemq";
  version = "5.15.13";

  src = fetchurl {
    sha256 = "1hzapnd0lbiid243xiaz8kv67al8griccjj4dabml62hqhrk9k96";
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
