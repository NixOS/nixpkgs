args: with args;

# at runtime, need jdk

stdenv.mkDerivation rec {
  name = "groovy-1.7.1";

  src = fetchurl {
    url = "http://dist.groovy.codehaus.org/distributions/groovy-binary-1.7.1.zip";
    sha256 = "0a204f6835f07e6a079bd4761e70cd5e0c31ebc0c9eb293fda11dfb2d8bf137c";
  };

  installPhase = ''
    ensureDir $out
    rm bin/*.bat
    mv * $out
  '';

  phases = "unpackPhase installPhase";

  buildInputs = [unzip];

  meta = {
    description = "An agile dynamic language for the Java Platform";
    homepage = http://groovy.codehaus.org/;
  };
}
