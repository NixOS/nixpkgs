{ stdenv, fetchurl, unzip, which, makeWrapper, jdk }:

# at runtime, need jdk

stdenv.mkDerivation rec {
  pname = "groovy";
  version = "2.5.9";

  src = fetchurl {
    url = "http://dl.bintray.com/groovy/maven/apache-groovy-binary-${version}.zip";
    sha256 = "16xq8mz7270kmiq4xb0g52y7ik1bbl2nb8aaz9zw8a9h38rdr9zy";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir -p $out
    mkdir -p $out/share/doc/groovy
    rm bin/*.bat
    mv {bin,conf,grooid,indy,lib} $out
    mv {licenses,LICENSE,NOTICE} $out/share/doc/groovy

    sed -i 's#which#${which}/bin/which#g' $out/bin/startGroovy

    for p in grape java2groovy groovy{,doc,c,sh,Console}; do
      wrapProgram $out/bin/$p \
            --set JAVA_HOME "${jdk}" \
            --prefix PATH ":" "${jdk}/bin"
    done
  '';

  meta = with stdenv.lib; {
    description = "An agile dynamic language for the Java Platform";
    homepage = http://groovy-lang.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
