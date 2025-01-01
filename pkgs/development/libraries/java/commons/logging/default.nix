{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "commons-logging";
  version = "1.3.1";

  src = fetchurl {
    url    = "mirror://apache/commons/logging/binaries/commons-logging-${version}-bin.tar.gz";
    sha256 = "sha256-mM85vfWDc88fNwwflvnRvoh/tb+jDH3o+96RZa9Sp7w=";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp commons-logging-*.jar $out/share/java/
  '';

  meta = {
    description = "Wrapper around a variety of logging API implementations";
    homepage = "https://commons.apache.org/proper/commons-logging";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}

