{ stdenv, fetchurl, unzip }:

# at runtime, need jdk

stdenv.mkDerivation rec {
  name = "groovy-${version}";
  version = "2.4.1";

  src = fetchurl {
    url = "http://dl.bintray.com/groovy/maven/groovy-binary-${version}.zip";
    sha256 = "1bhsv804iik497gflgp0wfhj6j4ylrladp1xndcszlfg576r1zch";
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
    homepage = http://groovy-lang.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
