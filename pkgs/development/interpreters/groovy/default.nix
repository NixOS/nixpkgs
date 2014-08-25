{ stdenv, fetchurl, unzip }:

# at runtime, need jdk

stdenv.mkDerivation rec {
  name = "groovy-${version}";
  version = "2.3.6";

  src = fetchurl {
    url = "http://dl.bintray.com/groovy/maven/groovy-binary-${version}.zip";
    sha256 = "0yvk6x1f68avl52zzwx9p3faiqr98rfps70vql05j6kd7syyp0ah";
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
