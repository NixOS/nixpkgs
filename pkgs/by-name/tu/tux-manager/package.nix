{
  lib,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tux-manager";
  version = "1.0.8";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "benapetr";
    repo = "TuxManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l59z4YcXzpXddxbDQhZvQ1QGsXTr2/e7DzPdttsawoc=";
  };

  nativeBuildInputs = with qt6; [
    qmake
    wrapQtAppsHook
  ];
  buildInputs = with qt6; [ qtbase ];

  configurePhase = ''
    runHook preConfigure

    # qmake's qtPrepareTool() hardcodes tool lookups to qtbase's own store
    # path at mkspecs-generation time, but nixpkgs ships lrelease in
    # qt6.qttools instead. Point it at the real binary explicitly.
    qmake6 $src/src "QT_TOOL.lrelease.binary=${qt6.qttools}/bin/lrelease"

    runHook postConfigure
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp tux-manager $out/bin/tux-manager

    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp ${finalAttrs.src}/src/tux_manager_icon.svg $out/share/icons/hicolor/scalable/apps/tux_manager_icon.svg

    mkdir -p $out/share/applications
    cp ${finalAttrs.src}/packaging/data/io.github.benapetr.TuxManager.desktop $out/share/applications/io.github.benapetr.TuxManager.desktop

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  qtWrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "/run/opengl-driver/lib"
  ];

  meta = {
    description = "Linux system monitor inspired by Windows Task Manager";
    longDescription = "A Linux Task Manager alternative built with Qt6, inspired by the Windows Task Manager but designed to go further - providing deep visibility into system processes, performance metrics, users, and services.";
    mainProgram = "tux-manager";
    homepage = "https://github.com/benapetr/TuxManager";
    downloadPage = "https://github.com/benapetr/TuxManager/releases/";
    changelog = "https://github.com/benapetr/TuxManager/blob/master/CHANGELOG.md#${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ phyrophone ];
  };
})
