{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "closure-compiler";
<<<<<<< HEAD
  version = "20230802";

  src = fetchurl {
    url = "mirror://maven/com/google/javascript/closure-compiler/v${version}/closure-compiler-v${version}.jar";
    sha256 = "sha256-IwqeBain2dqgg7H26G7bpusexkAqaiWEMv5CRc3EqV8=";
=======
  version = "20221102";

  src = fetchurl {
    url = "mirror://maven/com/google/javascript/closure-compiler/v${version}/closure-compiler-v${version}.jar";
    sha256 = "sha256-xaVAmt2GVywRVB7n6mqKqsYlfEAjRZEnfspf9c1Qluc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
