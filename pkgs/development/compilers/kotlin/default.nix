{ stdenv, fetchurl, makeWrapper, jre, unzip }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "kotlin-${version}";

  src = fetchurl {
    url = "https://github.com/JetBrains/kotlin/releases/download/${version}/kotlin-compiler-${version}.zip";
    sha256 = "1m3j1ca0kvryqarvpscrb9mvmsscd1sc8vfjsz03br6h2hwmnr3z";
  };

  propagatedBuildInputs = [ jre ] ;
  buildInputs = [ makeWrapper unzip ] ;

  installPhase = ''
    mkdir -p $out
    rm "bin/"*.bat
    mv * $out

    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p --prefix PATH ":" ${jre}/bin ;
    done
  '';

  meta = {
    description = "General purpose programming language";
    longDescription = ''
      Kotlin is a statically typed language that targets the JVM and JavaScript.
      It is a general-purpose language intended for industry use.
      It is developed by a team at JetBrains although it is an OSS language
      and has external contributors.
    '';
    homepage = http://kotlinlang.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers;
      [ nequissimus ];
    platforms = stdenv.lib.platforms.all;
  };
}
