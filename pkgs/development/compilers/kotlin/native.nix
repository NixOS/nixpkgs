{ lib
, stdenv
, fetchurl
, jre
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
  version = "1.6.20";

  src = let
    getArch = {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "x86_64-linux" = "linux-x86_64";
    }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

    getUrl = version: arch:
      "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-${arch}-${version}.tar.gz";

    getHash = arch: {
      "macos-aarch64" = "sha256-Nb/5UrNnIOJI+5PdXX4FfhUvCChrfUTkjaMS7nN/eGg=";
      "macos-x86_64" = "sha256-cgET1zjk14/o3EH/1t7jfCfXHwcjfAANKG+yxpQccMc=";
      "linux-x86_64" = "sha256-qbXyvCTGqRK0mCav6Ei128y1Ok1vfZ1o0haZ+MJjmBQ=";
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
