{
  stdenvNoCC,
  fetchurl,
  lib,
  gtk3,
  openjdk17,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  version = "2.1.20";

  jdk = openjdk17.override {
    enableJavaFX = true;
  };

  desktopItem = makeDesktopItem {
    name = "ugs-platform";
    desktopName = "Universal Gcode Sender (Platform)";
    genericName = "G-code Sender";
    comment = "Universal G-code Sender Platform UI";
    exec = "ugs-platform";
    icon = "ugsplatform";
    categories = [
      "Utility"
      "Engineering"
    ];
    startupWMClass = "UGSPlatform";
    terminal = false;
  };

  platforms = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/winder/Universal-G-Code-Sender/releases/download/v${version}/linux-x64-ugs-platform-app-${version}.tar.gz";
      sha256 = "sha256-dcFrrC/TBEJ2a1LsT+hLjiExTurEWX4QXXLWs55Ao4M=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/winder/Universal-G-Code-Sender/releases/download/v${version}/linux-aarch64-ugs-platform-app-${version}.tar.gz";
      sha256 = "sha256-x7zFu632m/HBfwf/z+znoJ05TPH7CmpFphuZvQAkgeg=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "ugs-platform";
  inherit version;

  src = platforms.${stdenvNoCC.system};

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt/ugs-platform"
    cp -ar . "$out/opt/ugs-platform/"

    # Drop bundled runtime (massive) — we use Nix JDK instead.
    rm -rf "$out/opt/ugs-platform/jdk"

    rm -rf "$out/opt/ugs-platform/"{java/docs,platform/docs}

    # Ensure it uses our Java, not any assumptions in the launcher.
    substituteInPlace "$out/opt/ugs-platform/bin/ugsplatform" \
      --replace "JAVA_HOME=" "JAVA_HOME=${jdk}\n"

    mkdir -p "$out/bin"
    makeWrapper "$out/opt/ugs-platform/bin/ugsplatform" "$out/bin/ugs-platform" \
      --set JAVA_HOME "${jdk}" \
      --add-flags "--jdkhome ${jdk}" \
      --prefix PATH : ${lib.makeBinPath [ jdk ]} \
      --prefix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}

    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    cp "$out/opt/ugs-platform/bin/icon.svg" \
      "$out/share/icons/hicolor/scalable/apps/ugsplatform.svg"

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "Cross-platform G-Code sender for GRBL, Smoothieware, TinyG and G2core";
    homepage = "https://github.com/winder/Universal-G-Code-Sender";
    maintainers = with maintainers; [ srounce ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "ugs-platform";
  };
}
