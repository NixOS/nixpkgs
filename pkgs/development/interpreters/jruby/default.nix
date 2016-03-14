{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "jruby-${version}";

  version = "9.0.5.0";

  src = fetchurl {
    url = "https://s3.amazonaws.com/jruby.org/downloads/${version}/jruby-bin-${version}.tar.gz";
    sha256 = "1wysymqzc7591743f2ycgwpm232y6i050izn72lck44nhnyr5wwy";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
     mkdir -pv $out/docs
     mv * $out
     rm $out/bin/*.{bat,dll,exe,sh}
     mv $out/COPYING $out/LICENSE* $out/docs

     for i in $out/bin/*; do
       wrapProgram $i \
         --set JAVA_HOME ${jre}
     done
  '';

  meta = {
    description = "Ruby interpreter written in Java";
    homepage = http://jruby.org/;
    license = with stdenv.lib.licenses; [ cpl10 gpl2 lgpl21 ];
  };
}
