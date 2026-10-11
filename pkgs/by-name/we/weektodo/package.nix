{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,

  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  jq,
  moreutils,
  electron,
  copyDesktopItems,
  makeDesktopItem,

  nix-update-script,
}:
let
  description = "Free and open-source minimalist weekly planner and to-do list app";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "weektodo";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "manuelernestog";
    repo = "weektodo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oOS7ylpB/x5fOPTEKO9gSOUH8REV8qLvF3zX3eX64zs=";
  };

  # Darwin requires writable Electron dist
  postUnpack =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        cp -r ${electron.dist} electron-dist
        chmod -R u+w electron-dist
      ''
    else
      ''
        ln -s ${electron.dist} electron-dist
      '';

  postPatch = ''
    # Unpin electron-builder version
    jq 'del(.resolutions)' package.json | sponge package.json
  '';

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-ii/DkEu0XUOe1MPBkxkPiyhRS1Suswk+sqp0KKy2RfI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
    jq
    moreutils
    copyDesktopItems
  ];

  yarnBuildScript = "electron:build";
  yarnBuildFlags = [
    "--dir"
    "-c.electronDist=electron-dist"
    "-c.electronVersion=${electron.version}"
    # Bug in electron-builder makes it rebuild native dependencies for Darwin on Linux for whatever reason
    # See https://github.com/electron-userland/electron-builder/issues/5015
    "-c.npmRebuild=false"
    # Fix entrypoint path
    "-c.extraMetadata.main=dist_electron/bundled/background.js"
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = true;
    ELECTRON_OVERRIDE_DIST_PATH = "electron-dist";
    # See https://github.com/webpack/webpack/issues/14532
    NODE_OPTIONS = "--openssl-legacy-provider";
  };

  installPhase =
    ''
      runHook preInstall
      mkdir -p $out/bin
    ''
    + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      mkdir -p $out/share/weektodo
      cp -r dist/*-unpacked/{locales,resources{,.pak}} -t $out/share/weektodo

      makeWrapper ${lib.getExe electron} $out/bin/weektodo \
        --add-flags "$out/share/weektodo/resources/app.asar" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \

      install -D build/icon/icon.png $out/share/icons/hicolor/512x512/apps/weektodo.png
    ''
    + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r dist/mac*/WeekToDo.app $out/Applications
      ln -s "$out/Applications/WeekToDo.app/Contents/MacOS/WeekToDo" $out/bin/weektodo
    ''
    + ''
      runHook postInstall
    '';

  desktopItems = lib.optional stdenvNoCC.hostPlatform.isLinux (makeDesktopItem {
    name = "weektodo";
    desktopName = "WeekToDo";
    comment = description;
    icon = "weektodo";
    exec = "weektodo %U";
    terminal = false;
    categories = [ "Utility" ];
  });

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit description;
    homepage = "https://weektodo.me/";
    changelog = "https://github.com/manuelernestog/weektodo/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Only ];
    inherit (electron.meta) platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "weektodo";
  };
})
