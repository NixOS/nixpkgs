{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "jruby-${version}";

  version = "1.7.12";

  src = fetchurl {
    url = "http://jruby.org.s3.amazonaws.com/downloads/${version}/jruby-bin-${version}.tar.gz";
    sha1 = "056cee1138e49da40a77f179b771372692479002";
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
    license = "CPL-1.0 GPL-2 LGPL-2.1"; # one of those
  };
}
