{ lib
, stdenv
, fetchurl
, jre
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
<<<<<<< HEAD
  version = "1.9.10";
=======
  version = "1.8.21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = let
    getArch = {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "x86_64-linux" = "linux-x86_64";
    }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

    getUrl = version: arch:
      "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-${arch}-${version}.tar.gz";

    getHash = arch: {
<<<<<<< HEAD
      "macos-aarch64" = "1pn371hy6hkyji4vkfiw3zw30wy0yyfhkxnkkyr8m0609945mkyj";
      "macos-x86_64" = "13c28czvja93zaff0kzqf8crzh998l90gznq0cl6k2j3c0jhyrgm";
      "linux-x86_64" = "0nxaiwn4akfpkibq42y8kfn5hdd7vzkm296qx4a9ai7l36cngcqx";
=======
      "macos-aarch64" = "06sjlwsk1854c6qpxbfqccvcyk4i8dv13jbc7s7lamgd45wrb5qa";
      "macos-x86_64" = "1mkzcwya5mjn0hjxmx8givmx9y1v4hy0cqayya20rvk10jngsfz7";
      "linux-x86_64" = "1kv81ilp2dzhxx0kbqkl0i43b44vr5dvni607k78vn6n3mj59j0g";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
