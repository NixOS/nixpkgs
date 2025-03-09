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
  trayEnabled ? true,
  # Whether to leave application in tray disregarding of its play state
  trayAlways ? false,
}:
stdenvNoCC.mkDerivation rec {
  pname = "yandex-music";
  version = "5.41.1";

  src = fetchFromGitHub {
    owner = "cucumber-sp";
    repo = "yandex-music-linux";
    rev = "v${version}";
    hash = "sha256-/Mz8lazGMZmziqSEK8zS6dI1PvnAc5PNAGd+MqTCoo4=";
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
    ''
    + optionalString trayEnabled ''
      TRAY_ENABLED=1
    ''
    + optionalString trayAlways ''
      ALWAYS_LEAVE_TO_TRAY=1
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
