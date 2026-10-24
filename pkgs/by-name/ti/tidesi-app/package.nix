{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  python3,
  qt6,
  libsecret,
  nix-update-script,
}:

let
  python = python3.withPackages (ps: [
    ps.pyside6
    ps.psutil
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tidesi-app";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Muddyblack";
    repo = "tidesi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0pKW+8WyGFoSx2MfbS6+0VhfYjm5gUyfRAWYayVpuhk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwayland
  ];

  dontWrapQtApps = true;
  strictDeps = true;
  __structuredAttrs = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    root=$out/share/tidesi
    mkdir -p "$root/hosts" "$out/bin"
    cp -r hosts/desktop "$root/hosts/desktop"
    cp -r ui backend assets translate "$root/"
    find "$root" \( -name '__pycache__' -o -name '*.pyc' \) -prune -exec rm -rf {} +

    # Remote devices reuse Antigravity's Secret Service credential.
    substituteInPlace "$root/backend/tidesi/providers/antigravity_remote.py" \
      --replace-fail 'SECRET_TOOL = "secret-tool"' \
                     'SECRET_TOOL = "${lib.getExe' libsecret "secret-tool"}"'

    install -Dm644 assets/icons/org.muddyblack.tidesi.svg \
      "$out/share/icons/hicolor/scalable/apps/org.muddyblack.tidesi.svg"

    # PySide6 ships no QML modules (QtQuick.Controls ...): they come from
    # qtdeclarative, the same Qt it runs on.
    makeWrapper ${python.interpreter} "$out/bin/tidesi" \
      --add-flags "-B $root/hosts/desktop/app.py" \
      --prefix QML_IMPORT_PATH : ${qt6.qtdeclarative}/${qt6.qtbase.qtQmlPrefix} \
      --prefix QT_PLUGIN_PATH : ${qt6.qtsvg}/${qt6.qtbase.qtPluginPrefix}
    wrapQtApp "$out/bin/tidesi"

    runHook postInstall
  '';

  # One instance per user: launching it again while it runs hands over to the
  # running one, so the menu entry and an autostart entry can coexist.
  desktopItems = [
    (makeDesktopItem {
      name = "org.muddyblack.tidesi";
      desktopName = "tideSI";
      genericName = "AI usage monitor";
      comment = finalAttrs.meta.description;
      exec = "tidesi";
      icon = "org.muddyblack.tidesi";
      categories = [ "Utility" ];
      keywords = [
        "AI"
        "quota"
        "usage"
        "Claude"
        "Codex"
      ];
    })
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$TMPDIR XDG_RUNTIME_DIR=$TMPDIR QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software
    $out/bin/tidesi --selftest
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tray app with a floating pill showing AI provider usage limits, for any desktop with a tray";
    homepage = "https://github.com/Muddyblack/tidesi";
    changelog = "https://github.com/Muddyblack/tidesi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "tidesi";
    maintainers = [ lib.maintainers.muddyblack ];
  };
})
