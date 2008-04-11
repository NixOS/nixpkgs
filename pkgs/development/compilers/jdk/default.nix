args: with args;

stdenv.mkDerivation rec {
  name = "scala-2.7.0-final";

  src = fetchurl {
    url = "http://www.scala-lang.org/downloads/distrib/files/${name}.tar.bz2";
    sha256 = "17b9711bfddac611e907659cab4cb51f4114b886bbee243274d774b691dae248";
  };

  installPhase = ''
    mkdir -p $out
    mv * $out
    rm -f $out/bin/*.bat
  '';

  phases = "unpackPhase installPhase";

  meta = {
    description = "Scala is a general purpose programming language";
  };
}
