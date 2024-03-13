{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "commons-logging";
  version = "1.3.0";

  src = fetchurl {
    url    = "mirror://apache/commons/logging/binaries/commons-logging-${version}-bin.tar.gz";
    sha256 = "sha256-ij6jOi1Y/iQ/9Ht41nKtmOdZCvf0NmNseFGxBpyq1fg=";
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

