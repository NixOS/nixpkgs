{
  stdenv,
  lib,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  jre,
  fetchzip,
}:
let
  desktopItem = makeDesktopItem {
    name = "ugs-platform";
    exec = "ugs-platform";
    comment = "The next generation platform-based interface. A G-Code sender for GRBL, Smoothieware, TinyG and G2core";
    desktopName = "Universal-G-Code-Sender-Platform";
    categories = [ "Utilities" ];
  };

in
stdenv.mkDerivation rec {
  pname = "ugs-platform";
  version = "2.1.18";

  src = fetchzip {
    url = "https://github.com/winder/Universal-G-Code-Sender/releases/download/v${version}/linux-x64-ugs-platform-app-${version}.tar.gz";
    hash = "sha256-oIMD9Ey2LcrzeRpBliMbyfpSW0aopfFVACZDTqRNqOg=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    # If there's a fat JAR, install it; otherwise install NetBeans app layout
    jar=$(find ${src} -name 'UniversalGcodeSender.jar' -print -quit || true)
    if [ -n "$jar" ]; then
      mkdir -p $out/share/ugs
      install -Dm644 "$jar" "$out/share/ugs/UniversalGcodeSender.jar"

      makeWrapper ${jre}/bin/java $out/bin/ugs \
        --prefix PATH : ${lib.makeBinPath [ jre ]} \
        --add-flags "-jar $out/share/ugs/UniversalGcodeSender.jar"
    else
      # NetBeans platform app: copy full source layout and wrap the platform launcher
      mkdir -p $out/share/ugs
      # Copy source excluding bundled JDK so we don't ship foreign dynamic executables
      (cd ${src} && tar --exclude='./jdk' -cf - .) | (cd $out/share/ugs && tar -xf -)
      chmod -R a+rX $out/share/ugs

      # Wrap the platform launcher so it uses the supplied jre
      makeWrapper $out/share/ugs/bin/ugsplatform $out/bin/ugs \
        --prefix PATH : ${lib.makeBinPath [ jre ]} \
        --add-flags "--jdkhome ${jre}"
    fi

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = {
    description = "The next generation platform-based interface. A G-Code sender for GRBL, Smoothieware, TinyG and G2core";
    homepage = "https://github.com/winder/Universal-G-Code-Sender";
    maintainers = with lib.maintainers; [ pslind17 ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "ugs-platform";
  };
}
