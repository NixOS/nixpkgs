{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.3";
  name    = "commons-math-${version}";

  src = fetchurl {
    url    = "mirror://apache/commons/math/binaries/commons-math3-${version}-bin.tar.gz";
    sha256 = "1xs71c4vbai6zr84982g4ggv6c18dhkilkzw9n1irjqnjbgm5kzc";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "http://commons.apache.org/proper/commons-math/";
    description = "A library of lightweight, self-contained mathematics and statistics components";
    maintainers = with stdenv.lib.maintainers; [ copumpkin ];
    license     = stdenv.lib.licenses.asl20;
    platforms = with stdenv.lib.platforms; unix;
  };
}
