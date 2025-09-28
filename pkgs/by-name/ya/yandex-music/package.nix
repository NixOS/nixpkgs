{
  fetchurl,
  stdenvNoCC,
  lib,
  makeWrapper,
  p7zip,
  asar,
  jq,
  python3,
  electron,
  fetchFromGitHub,
  electronArguments ? "",

  # Whether to enable tray menu by default
  trayEnabled ? true,
  # Style of tray: 1 - default style, 2 - mono black, 3 - mono white
  trayStyle ? 1,
  # Whether to leave application in tray disregarding of its play state
  trayAlways ? false,
  # Whether to enable developers tools
  devTools ? false,
  # Vibe animation FPS can be  from 0 (black screen) to any reasonable number.
  # Recommended 25 - 144. Default 25.
  vibeAnimationMaxFps ? 25,
  # Yandex Music's custom Windows-styled titlebar. Also makes the window frameless.
  customTitleBar ? false,
}:
assert lib.assertMsg (trayStyle >= 1 && trayStyle <= 3) "Tray style must be withing 1 and 3";
assert lib.assertMsg (vibeAnimationMaxFps >= 0) "Vibe animation max FPS must be greater then 0";
stdenvNoCC.mkDerivation rec {
  pname = "yandex-music";
  version = "5.63.1";

  src = fetchFromGitHub {
    owner = "cucumber-sp";
    repo = "yandex-music-linux";
    # tags are retagged for some bug fixes
    rev = "066a6c7f503304d2181db04c5ed379a80f9137b8";
    hash = "sha256-z+gmUG0/7ykF42+OlFGZC268Tj8+vpfgZRYrW4otpfM=";
  };

  nativeBuildInputs = [
    p7zip
    asar
    jq
    python3
    makeWrapper
  ];

  passthru.updateScript = ./update.sh;

  ymExe =
    let
      ym_info = builtins.fromJSON (builtins.readFile ./ym_info.json);
    in
    fetchurl {
      url = ym_info.exe_link;
      hash = ym_info.exe_hash;
    };

  buildPhase = ''
    runHook preBuild
    bash "./repack.sh" -o "./app" "$ymExe"
    runHook postBuild
  '';

  config =
    let
      inherit (lib) optionalString;
    in
    ''
      ELECTRON_ARGS="${electronArguments}"
      VIBE_ANIMATION_MAX_FPS=${toString vibeAnimationMaxFps}
    ''
    + optionalString trayEnabled ''
      TRAY_ENABLED=${toString trayStyle}
    ''
    + optionalString trayAlways ''
      ALWAYS_LEAVE_TO_TRAY=1
    ''
    + optionalString devTools ''
      DEV_TOOLS=1
    ''
    + optionalString customTitleBar ''
      CUSTOM_TITLE_BAR=1
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/nodejs"
    mv app/yandex-music.asar "$out/share/nodejs"

    CONFIG_FILE="$out/share/yandex-music.conf"
    echo "$config" >> "$CONFIG_FILE"

    install -Dm755 "$src/templates/yandex-music.sh" "$out/bin/yandex-music"
    substituteInPlace "$out/bin/yandex-music"                                  \
      --replace-fail "%electron_path%" "${electron}/bin/electron"              \
      --replace-fail "%asar_path%" "$out/share/nodejs/yandex-music.asar"

    wrapProgram "$out/bin/yandex-music"                                        \
      --set-default YANDEX_MUSIC_CONFIG "$CONFIG_FILE"

    install -Dm644 "./app/favicon.png" "$out/share/pixmaps/yandex-music.png"
    install -Dm644 "./app/favicon.png" "$out/share/icons/hicolor/48x48/apps/yandex-music.png"
    install -Dm644 "./app/favicon.svg" "$out/share/icons/hicolor/scalable/apps/yandex-music.svg"

    install -Dm644 "$src/templates/desktop" "$out/share/applications/yandex-music.desktop"

    runHook postInstall
  '';

  meta = {
    description = "Personal recommendations, selections for any occasion and new music";
    homepage = "https://music.yandex.ru/";
    downloadPage = "https://music.yandex.ru/download/";
    changelog = "https://github.com/cucumber-sp/yandex-music-linux/releases/tag/v${version}";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ shved ];
  };
}
