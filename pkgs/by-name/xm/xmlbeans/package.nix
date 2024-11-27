{ lib, stdenv, fetchzip, jre_headless }:

stdenv.mkDerivation rec {
  pname = "xmlbeans";
  version = "5.1.1-20220819";

  src = fetchzip {
    # old releases are deleted from the cdn
    url = "https://web.archive.org/web/20230313151507/https://dlcdn.apache.org/poi/xmlbeans/release/bin/xmlbeans-bin-${version}.zip";
    sha256 = "sha256-TDnWo1uJWL6k6Z8/uaF2LBNzRVQMHYopYze/2Fb/0aI=";
  };

  postPatch = ''
    rm bin/*.cmd
    substituteInPlace bin/dumpxsb \
      --replace 'echo `dirname $0`' ""

    substituteInPlace bin/_setlib \
      --replace 'echo XMLBEANS_LIB=$XMLBEANS_LIB' ""

    for file in bin/*; do
      substituteInPlace $file \
        --replace "java " "${jre_headless}/bin/java "
    done
  '';

  installPhase = ''
    mkdir -p $out
    chmod +x bin/*
    cp -r bin/ lib/ $out/
  '';

  meta = with lib; {
    description = "Java library for accessing XML by binding it to Java types";
    homepage = "https://xmlbeans.apache.org/";
    downloadPage = "https://dlcdn.apache.org/poi/xmlbeans/release/bin/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
