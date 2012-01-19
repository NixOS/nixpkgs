{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation {
  name = "jruby-1.6.5.1";

  src = fetchurl {
    url = http://jruby.org.s3.amazonaws.com/downloads/1.6.5.1/jruby-bin-1.6.5.1.tar.gz;
    sha256 = "1j0iv1q950lyir9vqfgg2533f1q28jaz7vnxqswsaix1mjhm29qd";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
     ensureDir $out
     mv * $out
     rm $out/bin/*.{bat,dll,exe,sh}
     mv $out/README $out/docs

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
