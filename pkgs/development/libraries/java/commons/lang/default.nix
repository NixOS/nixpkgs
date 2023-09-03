{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.13.0";
  pname = "commons-lang";

  src = fetchurl {
    url = "mirror://apache/commons/lang/binaries/commons-lang3-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-yDEbe1wqyfxuJe2DK55YnNLKLh7JcsHAgp2OohWBwWU=";
  };

  installPhase = ''
    runHook preInstall
    tar xf ${finalAttrs.src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
    runHook postInstall
  '';

  meta = {
    description = "Provides additional methods to manipulate standard Java library classes";
    homepage = "https://commons.apache.org/proper/commons-lang";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ copumpkin ];
    platforms = with lib.platforms; unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
