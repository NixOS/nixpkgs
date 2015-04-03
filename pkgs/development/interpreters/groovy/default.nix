{ stdenv, fetchurl, unzip }:

# at runtime, need jdk

stdenv.mkDerivation rec {
  name = "groovy-${version}";
  version = "2.4.2";

  src = fetchurl {
    url = "http://dl.bintray.com/groovy/maven/groovy-binary-${version}.zip";
    sha256 = "02vbg9ywn76rslkinjk1dw3wrj76p5bahbhvz71drlp30cs1r28w";
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
