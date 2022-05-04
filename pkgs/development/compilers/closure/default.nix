{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "closure-compiler";
  version = "20220202";

  src = fetchurl {
    url = "mirror://maven/com/google/javascript/closure-compiler/v${version}/closure-compiler-v${version}.jar";
    sha256 = "sha256-I9kcK9oL6AMStI7eGfruJ+CYQuAsVsixTzkh0JWJrw8=";
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
