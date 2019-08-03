{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.9";
  name    = "commons-lang-${version}";

  src = fetchurl {
    url    = "mirror://apache/commons/lang/binaries/commons-lang3-${version}-bin.tar.gz";
    sha256 = "0l0q1hnicvpbjmxl81ig3rwc212x5sdfnlg3cniwbmnx8fxjgbki";
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
