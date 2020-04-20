{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.10";
  pname = "commons-lang";

  src = fetchurl {
    url    = "mirror://apache/commons/lang/binaries/commons-lang3-${version}-bin.tar.gz";
    sha256 = "144057jrx1jral6dnnb039h3k8rnrx0nj3ii428s725jfhazg68f";
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
