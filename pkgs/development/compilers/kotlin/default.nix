{ stdenv, fetchurl, makeWrapper, jre, unzip }:

stdenv.mkDerivation rec {
  version = "1.0.3";
  name = "kotlin-${version}";

  src = fetchurl {
    url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-compiler-${version}.zip";
    sha256 = "15ywjv46i2d7zgg2b3vdklc6agr62nvn0gkz7k9hql78ccfmyq9p";
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
