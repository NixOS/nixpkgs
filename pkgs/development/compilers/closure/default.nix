{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  name = "closure-compiler-${version}";
  version = "20190121";

  src = fetchurl {
    url = "https://dl.google.com/closure-compiler/compiler-${version}.tar.gz";
    sha256 = "1jxxj3a1pbf7bbqs0rkqk28ii1r3w2va4iis8fffx8zfvbgncwyc";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp closure-compiler-v${version}.jar $out/share/java
    makeWrapper ${jre}/bin/java $out/bin/closure-compiler \
      --add-flags "-jar $out/share/java/closure-compiler-v${version}.jar"
  '';

  meta = with stdenv.lib; {
    description = "A tool for making JavaScript download and run faster";
    homepage = https://developers.google.com/closure/compiler/;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
