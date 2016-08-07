{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.4";
  name    = "commons-io-${version}";

  src = fetchurl {
    url    = "mirror://apache/commons/io/binaries/${name}-bin.tar.gz";
    sha256 = "0m5xmjfr9k2zmbrz425q530jd0lm6368c4wm3jsjlsrqmqjpsvz1";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "http://commons.apache.org/proper/commons-io";
    description = "A library of utilities to assist with developing IO functionality";
    maintainers = with stdenv.lib.maintainers; [ copumpkin ];
    license     = stdenv.lib.licenses.asl20;
    platforms = with stdenv.lib.platforms; unix;
  };
}
