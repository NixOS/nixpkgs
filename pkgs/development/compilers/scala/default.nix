{ stdenv, fetchurl }:

# at runtime, need jre or jdk

stdenv.mkDerivation rec {
  name = "scala-2.9.2";

  src = fetchurl {
    url = "http://www.scala-lang.org/downloads/distrib/files/${name}.tgz";
    sha256 = "0s1shpzw2hyz7bwxdqq19rcrzbpq4d7b0kvdvjvhy7h05x496b46";
  };

  installPhase = ''
    mkdir -p $out
    rm "bin/"*.bat
    mv * $out
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
