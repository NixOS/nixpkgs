{
  lib,
  stdenv,
  fetchurl,
  unzip,
  which,
  makeWrapper,
  jdk,
}:

# at runtime, need jdk

stdenv.mkDerivation rec {
  pname = "groovy";
  version = "3.0.11";

  src = fetchurl {
    url = "mirror://apache/groovy/${version}/distribution/apache-groovy-binary-${version}.zip";
    sha256 = "85abb44e81f94d794230cf5c2c7f1003e598a5f8a6ae04322f28c6f9efe395f6";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

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

  meta = with lib; {
    description = "An agile dynamic language for the Java Platform";
    homepage = "http://groovy-lang.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
