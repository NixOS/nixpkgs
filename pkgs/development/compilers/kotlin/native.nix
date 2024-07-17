{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
  version = "1.9.23";

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
        "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-${arch}-${version}.tar.gz";

      getHash =
        arch:
        {
          "macos-aarch64" = "1v1ld4nxa77vjxiz4jw5h29s8i4ghfbmq0d01r15i75pr46md8r7";
          "macos-x86_64" = "05ywdhagj3qzjaw5sd94sgjk89dysky7d7lfqpwvc8s35v77rv8f";
          "linux-x86_64" = "1j2lpl1r7r30dgard6ia29n3qrsr98wb3qwpc80z4jh6k42qn6id";
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
