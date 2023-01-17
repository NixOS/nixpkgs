{ lib
, stdenv
, fetchurl
, jre
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
  version = "1.8.0";

  src = let
    getArch = {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "x86_64-linux" = "linux-x86_64";
    }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

    getUrl = version: arch:
      "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-${arch}-${version}.tar.gz";

    getHash = arch: {
      "macos-aarch64" = "19dcc2ylh11vxirglda8xrrm06i2nd53ndd8b1smf2vyj0v9593m";
      "macos-x86_64" = "0pkc4g09qwp4lcvs62qis0zxdjbr9z5mbgyi4mczxx5kqha4fxp3";
      "linux-x86_64" = "124nvhjh9xj8nsdjf71vzsgfjdq6mc0nalk79xfvsp2wh7xd8d0n";
    }.${arch};
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
