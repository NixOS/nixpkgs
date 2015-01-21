{ stdenv, fetchurl, unzip }:

# at runtime, need jdk

stdenv.mkDerivation rec {
  name = "groovy-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "http://dl.bintray.com/groovy/maven/groovy-binary-${version}.zip";
    sha256 = "1wb0rb89mvy1x64a8z9z3jmphw72vnkxaqbc0f2v35c2wv61p839";
  };

  installPhase = ''
    mkdir -p $out
    rm bin/*.bat
    mv * $out
  '';

  phases = "unpackPhase installPhase";

  buildInputs = [ unzip ];

  meta = with stdenv.lib; {
    description = "An agile dynamic language for the Java Platform";
    homepage = http://groovy.codehaus.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
