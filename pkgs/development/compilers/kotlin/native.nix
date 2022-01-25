{ lib
, stdenv
, fetchurl
, jre
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
  version = "1.6.10";

  src = let
    getArch = {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "x86_64-linux" = "linux-x86_64";
    }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

    getUrl = version: arch:
      "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-${arch}-${version}.tar.gz";

    getHash = arch: {
      "macos-aarch64" = "sha256-W+9F1YZ5ATa6KaALYQEXW4xr4UxfquuC72xoB2987iM=";
      "macos-x86_64" = "sha256-pceORt+YJZiP67nbnUB6ny1ic/r0aTrdA2hsQi5Otp8=";
      "linux-x86_64" = "sha256-tcZffJPcR6PYJ22wIh5BHn/yjG3Jb+MG5COLbAQ2/Ww=";
    }.${arch};
  in
    fetchurl {
      url = getUrl version getArch;
      hash = getHash getArch;
    };

  nativeBuildInputs = [
    jre
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    rm bin/kotlinc
    mv * $out

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/run_konan --prefix PATH ":" ${lib.makeBinPath [ jre ]}
  '';

  meta = {
    homepage = "https://kotlinlang.org/";
    description = "A modern programming language that makes developers happier";
    longDescription = ''
      Kotlin/Native is a technology for compiling Kotlin code to native
      binaries, which can run without a virtual machine. It is an LLVM based
      backend for the Kotlin compiler and native implementation of the Kotlin
      standard library.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianhjr ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
  };
}
