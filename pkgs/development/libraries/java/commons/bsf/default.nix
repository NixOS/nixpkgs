{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "commons-bsf";
  version = "2.4.0";

  src = fetchurl {
    url = "mirror://apache/commons/bsf/binaries/bsf-bin-${version}.tar.gz";
    sha256 = "1my3hv4y8cvrd1kr315wvbjqsamzlzswnbqcmsa2m4hqcafddfr8";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp lib/bsf.jar $out/share/java/
  '';

  meta = {
    description = "Interface to scripting languages, including JSR-223";
    homepage = "https://commons.apache.org/proper/commons-bsf/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}

