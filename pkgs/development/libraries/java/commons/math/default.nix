{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.6.1";
  pname = "commons-math";

  src = fetchurl {
    url    = "mirror://apache/commons/math/binaries/commons-math3-${version}-bin.tar.gz";
    sha256 = "0x4nx5pngv2n4ga11c1s4w2mf6cwydwkgs7da6wwvcjraw57bhkz";
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
