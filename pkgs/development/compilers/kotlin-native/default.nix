{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
  version = "1.5.21";

  src = fetchurl {
    url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-linux-${version}.tar.gz";
    hash = "sha256-+j3+ycEXEcK3E6FIK8xFEbuPc/GC8Sqn2FiUP28IQ5c=";
  };

  nativeBuildInputs = [ makeWrapper ] ;

  installPhase = ''
    mkdir -p $out
    mv * $out

    wrapProgram $out/bin/run_konan --prefix PATH ":" ${lib.makeBinPath [ jre ]}
  '';

  meta = with lib; {
    description = "An LLVM backend for the Kotlin compiler";
    longDescription = ''
      Kotlin/Native is an LLVM backend for the Kotlin compiler, runtime
      implementation, and native code generation facility using the LLVM
      toolchain.
    '';
    homepage = "https://kotlinlang.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ malvo ];
    platforms = platforms.linux;
  };
}
