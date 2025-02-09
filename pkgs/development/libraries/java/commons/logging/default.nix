{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "commons-logging";
  version = "1.2";

  src = fetchurl {
    url    = "mirror://apache/commons/logging/binaries/commons-logging-${version}-bin.tar.gz";
    sha256 = "1gc70pmcv0x6ibl89jglmr22f8zpr63iaifi49nrq399qw2qhx9z";
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

