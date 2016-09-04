{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.3.2";
  name    = "commons-lang-${version}";

  src = fetchurl {
    url    = "mirror://apache/commons/lang/binaries/commons-lang3-${version}-bin.tar.gz";
    sha256 = "1fmcx52h4cd2b7bplm7wy3725vh8bix64j3ykkxcn357y4j8ddzr";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "http://commons.apache.org/proper/commons-lang";
    description = "Provides additional methods to manipulate standard Java library classes";
    maintainers = with stdenv.lib.maintainers; [ copumpkin ];
    license     = stdenv.lib.licenses.asl20;
    platforms = with stdenv.lib.platforms; unix;
  };
}
