{ stdenv, fetchurl, makeWrapper, jre, unzip, which }:

stdenv.mkDerivation rec {
  version = "1.0.0-beta-4583";
  name = "kotlin-${version}";

  src = fetchurl {
    url = "https://github.com/JetBrains/kotlin/releases/download/build-${version}/kotlin-compiler-${version}.zip";
    sha256 = "4db71d3c1f150618568ebd1f8c17567ff15afe022c2f0121368c17afad9e8188";
  };

  propagatedBuildInputs = [ jre which ] ;
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
