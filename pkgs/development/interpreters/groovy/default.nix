{ stdenv, fetchurl, unzip, which, makeWrapper, jdk }:

# at runtime, need jdk

stdenv.mkDerivation rec {
  name = "groovy-${version}";
  version = "2.4.6";

  src = fetchurl {
    url = "http://dl.bintray.com/groovy/maven/apache-groovy-binary-${version}.zip";
    sha256 = "0s474wy7db7j1pans5ks986b52bdmn40l29zl6xl44y23fsvagwv";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir -p $out
    rm bin/*.bat
    mv * $out

    sed -i 's#which#${which}/bin/which#g' $out/bin/startGroovy

    for p in grape java2groovy groovy{,doc,c,sh,Console}; do
      wrapProgram $out/bin/$p \
            --set JAVA_HOME "${jdk}" \
            --prefix PATH ":" "${jdk}/bin"
    done
  '';

  phases = "unpackPhase installPhase";

  meta = with stdenv.lib; {
    description = "An agile dynamic language for the Java Platform";
    homepage = http://groovy-lang.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
