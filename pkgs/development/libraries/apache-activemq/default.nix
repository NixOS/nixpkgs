{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "apache-activemq";
<<<<<<< HEAD
  version = "5.18.2";

  src = fetchurl {
    sha256 = "sha256-zT3z7C95HUf0NRvA5dX5iAwiCkUaMYIO2/g5li7IQwo=";
=======
  version = "5.18.1";

  src = fetchurl {
    sha256 = "sha256-/t173pr1urrrByv3rrIGXZAhwmFj3tY5yHoy1nN5VHI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
