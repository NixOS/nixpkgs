{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "jruby-${version}";

  version = "1.7.21";

  src = fetchurl {
    url = "http://jruby.org.s3.amazonaws.com/downloads/${version}/jruby-bin-${version}.tar.gz";
    sha1 = "4955b69a913b22f96bd599eff2a133d8d1ed42c6";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
     mkdir -pv $out
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
