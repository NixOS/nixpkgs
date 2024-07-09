{ lib, stdenv, fetchurl, unzip, which, makeWrapper, jdk }:

# at runtime, need jdk

stdenv.mkDerivation rec {
  pname = "groovy";
  version = "4.0.22";

  src = fetchurl {
    url = "mirror://apache/groovy/${version}/distribution/apache-groovy-binary-${version}.zip";
    sha256 = "sha256-2Ro93+NThx1MJlbT0KBcgovD/zbp1J29vsE9zZjwWHc=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  installPhase = ''
    mkdir -p $out
    mkdir -p $out/share/doc/groovy
    rm bin/*.bat
    mv {bin,conf,grooid,lib} $out
    mv {licenses,LICENSE,NOTICE} $out/share/doc/groovy

    sed -i 's#which#${which}/bin/which#g' $out/bin/startGroovy

    for p in grape java2groovy groovy{,doc,c,sh,Console}; do
      wrapProgram $out/bin/$p \
            --set JAVA_HOME "${jdk}" \
            --prefix PATH ":" "${jdk}/bin"
    done
  '';

  meta = with lib; {
    description = "Agile dynamic language for the Java Platform";
    homepage = "http://groovy-lang.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
