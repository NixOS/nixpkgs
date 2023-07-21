{ lib
, stdenv
, fetchurl
, jre
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
  version = "1.9.0";

  src = let
    getArch = {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "x86_64-linux" = "linux-x86_64";
    }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

    getUrl = version: arch:
      "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-${arch}-${version}.tar.gz";

    getHash = arch: {
      "macos-aarch64" = "0728zm72ywyl6yhrfkad3whg2xly9bx7whp8alfi980qf468b1jh";
      "macos-x86_64" = "09j2i06qypw7ag2wrfkci9gnvprj96n3362p5vynr65jrzm5b8ww";
      "linux-x86_64" = "1v58n8ap5kifhawz30lk6rb2sp0qyiiy8gihw2ngbbhvakkigg8q";
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
