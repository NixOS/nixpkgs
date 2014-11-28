{ stdenv, fetchurl, unzip }:

# at runtime, need jdk

stdenv.mkDerivation rec {
  name = "groovy-${version}";
  version = "2.3.8";

  src = fetchurl {
    url = "http://dl.bintray.com/groovy/maven/groovy-binary-${version}.zip";
    sha256 = "0fgsn1s7vhxcrwb2wa6zvrdzff7zbb2s6f7xj6c9x7gl9mdfcwpn";
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
