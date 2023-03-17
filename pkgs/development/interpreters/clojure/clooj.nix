{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "clooj";
  version = "0.4.4";

  jar = fetchurl {
    # mirrored as original mediafire.com source does not work without user interaction
    url = "https://archive.org/download/clooj-${version}-standalone/clooj-${version}-standalone.jar";
    sha256 = "0hbc29bg2a86rm3sx9kvj7h7db9j0kbnrb706wsfiyk3zi3bavnd";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/java
    ln -s $jar $out/share/java/clooj.jar
    makeWrapper ${jre}/bin/java $out/bin/clooj --add-flags "-jar $out/share/java/clooj.jar"
  '';

  meta = {
    description = "A lightweight IDE for Clojure";
    homepage = "https://github.com/arthuredelstein/clooj";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
