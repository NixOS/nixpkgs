{ lib, stdenv, fetchurl, makeWrapper, jre, unzip }:

let
  version = "1.5.31";
  homepage = "https://kotlinlang.org/";
  license = lib.licenses.asl20;
  description = "A modern programming language that makes developers happier";
in {
  kotlin = stdenv.mkDerivation rec {
    pname = "kotlin";
    inherit version;

    src = fetchurl {
      url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-compiler-${version}.zip";
      sha256 = "sha256-ZhERKG8+WsBqrzqUA9hp2alqF2tisUGBS+YmpHJJ/p4=";
    };

    propagatedBuildInputs = [ jre ];
    nativeBuildInputs = [ makeWrapper unzip ];

    installPhase = ''
      mkdir -p $out
      rm "bin/"*.bat
      mv * $out

      for p in $(ls $out/bin/) ; do
        wrapProgram $out/bin/$p --prefix PATH ":" ${jre}/bin ;
      done

      if [ -f $out/LICENSE ]; then
        install -D $out/LICENSE $out/share/kotlin/LICENSE
        rm $out/LICENSE
      fi
    '';
    meta = {
      inherit homepage license description;
      longDescription = ''
        Kotlin is a modern but already mature programming language aimed to make
        developers happier. It’s concise, safe, interoperable with Java and
        other languages, and provides many ways to reuse code between multiple
        platforms for productive programming.
      '';
      maintainers = with lib.maintainers; [ SubhrajyotiSen ];
      platforms = lib.platforms.all;
    };
  };

  kotlin-native = stdenv.mkDerivation rec {
    pname = "kotlin-native";
    inherit version;

    src = {
      aarch64-darwin = fetchurl {
        url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-macos-aarch64-${version}.tar.gz";
        sha256 = "00yqd7a562k2lsnxwxi6h690bprlpv5vfy6dy5zpsgi5c3ihbl7v";
      };
      x86_64-darwin = fetchurl {
        url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-macos-x86_64-${version}.tar.gz";
        sha256 = "1phs5l33hgvblwb46kqhd038lvwna56mvxfb9s9wv9h4ir525rzx";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-linux-x86_64-${version}.tar.gz";
        sha256 = "00xfvaxa687g4w0sda14n2c0y797qa77lrw4sahkzypfajg7wsv3";
      };
    }.${stdenv.system} or (throw "Unsupported sysetm: ${stdenv.system}");

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      mkdir -p $out
      mv * $out

      wrapProgram $out/bin/run_konan --prefix PATH ":" ${lib.makeBinPath [ jre ]}
    '';
    meta = {
      inherit homepage license description;
      longDescription = ''
        Kotlin/Native is a technology for compiling Kotlin code to native
        binaries, which can run without a virtual machine. It is an LLVM based
        backend for the Kotlin compiler and native implementation of the Kotlin
        standard library.
      '';
      maintainers = with lib.maintainers; [ fabianhjr malvo ];
      # Missing non-x86_64-linux (specially armv7a/aarch64)
      platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    };
  };
}
