{ stdenv, fetchurl }:

# at runtime, need jre or jdk

stdenv.mkDerivation rec {
  name = "scala-2.9.3";

  src = fetchurl {
    url = "http://www.scala-lang.org/files/archive/${name}.tgz";
    sha256 = "faaab229f78c945063e8fd31c045bc797c731194296d7a4f49863fd87fc4e7b9";
  };

  installPhase = ''
    mkdir -p $out
    rm bin/*.bat
    rm lib/scalacheck.jar
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
