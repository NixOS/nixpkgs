args: with args;

stdenv.mkDerivation rec {
  name = "scala-2.7.1";

  src = fetchurl {
    url = "http://www.scala-lang.org/downloads/distrib/files/${name}.final.tar.gz";
    sha256 = "3cad113ed7b84f4f009897f6066bee28459e63a1cf1a6d5d56f10f4d1f9819ec";
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
