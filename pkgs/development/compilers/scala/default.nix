{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "scala-2.11.0";

  src = fetchurl {
    url = "http://www.scala-lang.org/files/archive/${name}.tgz";
    sha256 = "00lap31c6rxvg7vipmj0j7f4mv6c58wpfyd3785bxwlhrzmmwgq7";
  };

  buildInputs = [ jre makeWrapper ] ;

  installPhase = ''
    mkdir -p $out
    rm "bin/"*.bat
    mv * $out

    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p --prefix PATH ":" ${jre}/bin ;
    done
  '';

  meta = {
    description = "Scala is a general purpose programming language";
    longDescription = ''
      Scala is a general purpose programming language designed to express
      common programming patterns in a concise, elegant, and type-safe way.
      It smoothly integrates features of object-oriented and functional
      languages, enabling Java and other programmers to be more productive.
      Code sizes are typically reduced by a factor of two to three when
      compared to an equivalent Java application.
    '';
    homepage = http://www.scala-lang.org/;
    license = "BSD";
    platforms = stdenv.lib.platforms.all;
  };
}
