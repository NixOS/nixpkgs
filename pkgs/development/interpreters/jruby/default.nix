{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "jruby-${version}";

  version = "9.1.5.0";

  src = fetchurl {
    url = "https://s3.amazonaws.com/jruby.org/downloads/${version}/jruby-bin-${version}.tar.gz";
    sha256 = "0rmpbg62cy06pq8xxmnkqc2m2c5kg1kj816wbrf7qjdlzfpg7r18";
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
    platforms = stdenv.lib.platforms.unix;
  };
}
