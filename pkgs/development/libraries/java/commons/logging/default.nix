{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "commons-logging-1.2";

  src = fetchurl {
    url    = mirror://apache/commons/logging/binaries/commons-logging-1.2-bin.tar.gz;
    sha256 = "1gc70pmcv0x6ibl89jglmr22f8zpr63iaifi49nrq399qw2qhx9z";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp commons-logging-*.jar $out/share/java/
  '';

  meta = {
    description = "Wrapper around a variety of logging API implementations";
    homepage = http://commons.apache.org/proper/commons-logging;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}

