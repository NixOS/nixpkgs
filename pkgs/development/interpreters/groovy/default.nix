{ stdenv, fetchurl, unzip, which, makeWrapper, jdk }:

# at runtime, need jdk

stdenv.mkDerivation rec {
  pname = "groovy";
  version = "3.0.2";

  src = fetchurl {
    url = "http://dl.bintray.com/groovy/maven/apache-groovy-binary-${version}.zip";
    sha256 = "1ddw3fqrmwh4w6z6xgck4jhmq33rwgbmpjw07g12ri1vgw4xks9w";
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
    homepage = "http://groovy-lang.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
