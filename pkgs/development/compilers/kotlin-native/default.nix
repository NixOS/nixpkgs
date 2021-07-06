{ stdenv, fetchurl, makeWrapper, jre, unzip }:

let
  version = "1.3.72";
in stdenv.mkDerivation {
  inherit version;
  pname = "kotlin-native";

  src = fetchurl {
    url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-linux-${version}.tar.gz";
    sha256 = "85534a02d7cb6c07f51945e98cd4c0f2644e8528176da17c351b605845857b8c";
  };

  propagatedBuildInputs = [ jre ] ;
  buildInputs = [ makeWrapper unzip ] ;

  installPhase = ''
    mkdir -p $out
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
    description = "General purpose programming language";
    longDescription = ''
      Kotlin/Native is a technology for compiling Kotlin code to native binaries, which can run without a virtual machine. It is an LLVM based backend for the Kotlin compiler and native implementation of the Kotlin standard library.
    '';
    homepage = "https://kotlinlang.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers;
      [ vctibor ];
    platforms = stdenv.lib.platforms.linux;
  };
}
