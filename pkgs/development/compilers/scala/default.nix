args: with args;

# at runtime, need jre or jdk

stdenv.mkDerivation rec {
  name = "scala-2.7.7";

  src = fetchurl {
    url = "http://www.scala-lang.org/downloads/distrib/files/${name}.final.tgz";
    md5 = "5d2294d5aab72fec869c0ba666d28b7e";
  };

  installPhase = ''
    ensureDir $out
    rm bin/*.bat
    mv * $out
  '';

  phases = "unpackPhase installPhase";

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
  };
}
