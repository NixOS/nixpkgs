{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "commons-bsf-1.2";

  src = fetchurl {
    url = mirror://apache/commons/bsf/binaries/bsf-bin-2.4.0.tar.gz;
    sha256 = "1my3hv4y8cvrd1kr315wvbjqsamzlzswnbqcmsa2m4hqcafddfr8";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp lib/bsf.jar $out/share/java/
  '';

  meta = {
    description = "Interface to scripting languages, including JSR-223";
    homepage = http://commons.apache.org/proper/commons-bsf/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}

