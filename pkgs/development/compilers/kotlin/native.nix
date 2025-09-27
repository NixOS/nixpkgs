{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
  version = "2.2.20";

  src =
    let
      getArch =
        {
          "aarch64-darwin" = "macos-aarch64";
          "x86_64-darwin" = "macos-x86_64";
          "x86_64-linux" = "linux-x86_64";
        }
        .${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

      getUrl =
        version: arch:
        "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-prebuilt-${arch}-${version}.tar.gz";

      getHash =
        arch:
        {
          "macos-aarch64" = "sha256-UnDl9wj/7RXrEaApuAaLczIfz0lscQPf+pCeSdJxJeY=";
          "macos-x86_64" = "sha256-mmsBQrx0yKqvvhnD8CU+oxqhWsOT1RzvzSniN3CeG7g=";
          "linux-x86_64" = "sha256-2Ff+4rTj/W0tQBo6lADcQMIN4dAj32UnIXF9PRme0Nw=";
        }
        .${arch};
    in
    fetchurl {
      url = getUrl version getArch;
      sha256 = getHash getArch;
    };

  nativeBuildInputs = [
    jre
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv * $out

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/run_konan --prefix PATH ":" ${lib.makeBinPath [ jre ]}
  '';

  meta = {
    homepage = "https://kotlinlang.org/";
    description = "Modern programming language that makes developers happier";
    longDescription = ''
      Kotlin/Native is a technology for compiling Kotlin code to native
      binaries, which can run without a virtual machine. It is an LLVM based
      backend for the Kotlin compiler and native implementation of the Kotlin
      standard library.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianhjr ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
  };
}
