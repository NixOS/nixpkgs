{stdenv, fetchurl, jre}:

stdenv.mkDerivation {
  name = "aspectj-1.5.2";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/aspectj/aspectj-1.5.2.jar;
    md5 = "64245d451549325147e3ca1ec4c9e57c";
  };

  inherit jre;
  buildInputs = [jre];

  meta = {
    homepage = http://www.eclipse.org/aspectj/;
    description = "A seamless aspect-oriented extension to the Java programming language";
    platforms = stdenv.lib.platforms.unix;
  };
}
