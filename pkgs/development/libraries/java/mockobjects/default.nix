{lib, stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "mockobjects-0.09";

  src = fetchurl {
    url = "mirror://sourceforge/mockobjects/mockobjects-bin-0.09.tar";
    sha256 = "18rnyqfcyh0s3dwkkaszdd50ssyjx5fa1y3ii309ldqg693lfgnz";
  };

  # Work around the "unpacker appears to have produced no directories"
  setSourceRoot = "sourceRoot=`pwd`";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp mockobjects-*.jar $out/share/java

    runHook postInstall
  '';

  meta = with lib; {
    description = "Generic unit testing framework and methodology for testing any kind of code";
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
