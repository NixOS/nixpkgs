{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "scala-2.11.7";

  src = fetchurl {
    url = "http://www.scala-lang.org/files/archive/${name}.tgz";
    sha256 = "1l16571fw5l339wd02w2pnr3556j804zpbsbymnad67f2dpikr7z";
  };

  propagatedBuildInputs = [ jre ] ;
  buildInputs = [ makeWrapper ] ;

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
      Scala is a general purpose programming language designed to express
      common programming patterns in a concise, elegant, and type-safe way.
      It smoothly integrates features of object-oriented and functional
      languages, enabling Java and other programmers to be more productive.
      Code sizes are typically reduced by a factor of two to three when
      compared to an equivalent Java application.
    '';
    homepage = http://www.scala-lang.org/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };
}
