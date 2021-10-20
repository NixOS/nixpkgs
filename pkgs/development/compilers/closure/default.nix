{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "closure-compiler";
  version = "20210808";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/com/google/javascript/closure-compiler/v${version}/closure-compiler-v${version}.jar";
    sha256 = "1cvibvm8l4mp64ml6lpsh3w62bgbr42pi3i7ga8ss0prhr0dsk3y";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp ${src} $out/share/java/closure-compiler-v${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/closure-compiler \
      --add-flags "-jar $out/share/java/closure-compiler-v${version}.jar"
  '';

  meta = with lib; {
    description = "A tool for making JavaScript download and run faster";
    homepage = "https://developers.google.com/closure/compiler/";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
