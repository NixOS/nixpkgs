{ lib
, stdenv
, fetchurl
, jre
, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "kamilalisp";
  version = "0.2p";

  src = fetchurl {
    url = "https://github.com/kspalaiologos/kamilalisp/releases/download/v${version}/kamilalisp-${lib.versions.majorMinor version}.jar";
    hash = "sha256-6asl9zRTidDxWsgIRxUA1ygYug/aqiQ5XAEwWYNOfKE=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${src} $out/share/java/${name}-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/kamilalisp \
      --add-flags "-jar $out/share/java/${name}-${version}.jar" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on' \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  '';

  meta = {
    homepage = "https://github.com/kspalaiologos/kamilalisp";
    description = "A functional, flexible, and concise Lisp";
    license = lib.licenses.gpl3Plus;
    inherit (jre.meta) platforms;
    maintainers = with lib.maintainers; [ cafkafk ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
