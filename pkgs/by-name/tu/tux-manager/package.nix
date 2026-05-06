{
  lib,
  fetchFromGitHub,
  stdenv,
  kdePackages,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tux-manager";
  version = "1.0.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "benapetr";
    repo = "TuxManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ko41pTGkWjCgKX65YmWt2KamlltIQkjmFIsl7fuMDK4=";
  };

  desktopItem = makeDesktopItem {
    name = finalAttrs.pname;
    desktopName = "Tux Manager";
    type = "Application";
    comment = "Linux system monitor inspired by Windows Task Manager";
    exec = "tux-manager";
    icon = "tux-manager";
    categories = [
      "System"
      "Monitor"
    ];
    terminal = false;
  };

  nativeBuildInputs = with kdePackages; [
    qmake
    wrapQtAppsHook
  ];
  buildInputs = with kdePackages; [ qtbase ];

  configurePhase = ''
    runHook preConfigure

    qmake6 $src/src;

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp tux-manager $out/bin/tux-manager

    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp ${finalAttrs.src}/src/tux_manager_icon.svg $out/share/icons/hicolor/scalable/apps/tux-manager.svg

    mkdir -p $out/share/applications
    ln -s ${finalAttrs.desktopItem}/share/applications/* $out/share/applications/

    runHook postInstall
  '';

  meta = {
    description = "Linux system monitor inspired by Windows Task Manager";
    longDescription = "A Linux Task Manager alternative built with Qt6, inspired by the Windows Task Manager but designed to go further - providing deep visibility into system processes, performance metrics, users, and services.";
    mainProgram = "tuxmanager";
    homepage = "https://github.com/benapetr/TuxManager";
    downloadPage = "https://github.com/benapetr/TuxManager/releases/";
    changelog = "https://github.com/benapetr/TuxManager/blob/master/CHANGELOG.md#${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ phyrophone ];
  };
})
