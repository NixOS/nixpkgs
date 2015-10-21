{ version, sha256, mkUrl }:
# use a function to make the source url, because the url schemes differ between 5.8.0 and greater
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "apache-activemq-${version}";

  src = fetchurl {
    url = mkUrl name;
    inherit sha256;
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
