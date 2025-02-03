{ lib, stdenv, fetchurl, makeWrapper, jre }:

let
  playerglobal_ver = "27.0";
  playerglobal = fetchurl {
    url = "https://fpdownload.macromedia.com/get/flashplayer/updaters/27/playerglobal27_0.swc";
    sha256 = "0qw2bgls8qsmp80j8vpd4c7s0c8anlrk0ac8z42w89bajcdbwk2f";
  };
in stdenv.mkDerivation rec {
  pname = "apache-flex-sdk";
  version = "4.16.1";

  src = fetchurl {
    url = "mirror://apache/flex/${version}/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "13iq16dqvgcpb0p35x66hzxsq5pkbr2lbwr766nnqiryinnagz8p";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jre ];

  dontBuild = true;

  postPatch = ''
    shopt -s extglob
    for i in bin/!(aasdoc|acompc|amxmlc); do
      substituteInPlace $i --replace "java " "${jre}/bin/java "
    done
  '';

  installPhase = ''
    t=$out/opt/apache-flex-sdk
    mkdir -p $t $out/bin
    mv * $t
    rm $t/bin/*.bat
    ln -s $t/bin/* $out/bin/

    for i in $out/bin/!(aasdoc|acompc|amxmlc); do
      wrapProgram $i \
        --set FLEX_HOME $t \
        --set PLAYERGLOBAL_HOME $t/frameworks/libs/player/
    done

    mkdir -p $t/frameworks/libs/player/${playerglobal_ver}/
    cp ${playerglobal} $t/frameworks/libs/player/${playerglobal_ver}/playerglobal.swc
  '';

  dontFixup = true;

  meta = with lib; {
    description = "Flex SDK for Adobe Flash / ActionScript";
    homepage = "https://flex.apache.org/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ dywedir ];
  };
}
