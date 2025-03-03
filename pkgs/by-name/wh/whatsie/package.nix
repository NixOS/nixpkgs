{
  fetchFromGitHub,
  lib,
  stdenv,
  makeDesktopItem,
  copyDesktopItems,
  libX11,
  libxcb,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whatsie";
  version = "4.16.3";

  src = fetchFromGitHub {
    owner = "keshavbhatt";
    repo = "whatsie";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-F6hQY3Br0iFDYkghBgRAyzLW6QhhG8UHOgkEgDjeQLg=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Whatsie";
      icon = finalAttrs.pname;
      exec = finalAttrs.pname;
      comment = finalAttrs.meta.description;
    })
  ];

  buildInputs = [
    libX11
    libxcb
    qt5.qtwebengine
  ];

  nativeBuildInputs = [
    copyDesktopItems
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  strictDeps = false;

  enableParallelBuilding = true;

  preBuild = ''
    export QT_WEBENGINE_ICU_DATA_DIR=${qt5.qtwebengine.out}/resources
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 whatsie -t $out/bin
    install -Dm644 $src/snap/gui/icon.svg $out/share/icons/hicolor/scalable/apps/whatsie.svg

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/keshavbhatt/whatsie";
    description = "Feature rich WhatsApp Client for Desktop Linux";
    license = lib.licenses.mit;
    mainProgram = "whatsie";
    maintainers = with lib.maintainers; [ ajgon ];
    platforms = lib.platforms.linux;
  };
})
