{ stdenv, fetchurl, makeWrapper, jre, unzip }:

let
  version = "1.3.61";
in stdenv.mkDerivation {
  inherit version;
  pname = "kotlin";

  src = fetchurl {
    url = "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-compiler-${version}.zip";
    sha256 = "073vb402b03llscgr298iih5lc3y1dn1qxyid2i9hiyrsld1a09r";
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

    if [ -f $out/LICENSE ]; then
      install -D $out/LICENSE $out/share/kotlin/LICENSE
      rm $out/LICENSE
    fi
  '';

  meta = {
    description = "General purpose programming language";
    longDescription = ''
      Kotlin is a statically typed language that targets the JVM and JavaScript.
      It is a general-purpose language intended for industry use.
      It is developed by a team at JetBrains although it is an OSS language
      and has external contributors.
    '';
    homepage = https://kotlinlang.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers;
      [ nequissimus ];
    platforms = stdenv.lib.platforms.all;
  };
}
