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
}:
stdenvNoCC.mkDerivation rec {
  pname = "yandex-music";
  version = "5.15.0";

  src = fetchFromGitHub {
    owner = "cucumber-sp";
    repo = "yandex-music-linux";
    rev = "v${version}";
    hash = "sha256-c+OKyhbgpXMryc6QQH4b5cePlqyHeSfDh4kT2rU+Tpo=";
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
      url = ym_info.ym.exe_link;
      sha256 = ym_info.ym.exe_sha256;
    };

  buildPhase = ''
    runHook preBuild
    bash "./repack.sh" -o "./app" "$ymExe"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/nodejs"
    mv app/yandex-music.asar "$out/share/nodejs"

    CONFIG_FILE="$out/share/yandex-music.conf"
    echo "TRAY_ENABLED=${if trayEnabled then "1" else "0"}" >> "$CONFIG_FILE"
    echo "ELECTRON_ARGS=\"${electronArguments}\"" >> "$CONFIG_FILE"


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
    description = "Yandex Music - Personal recommendations, selections for any occasion and new music";
    homepage = "https://music.yandex.ru/";
    downloadPage = "https://music.yandex.ru/download/";
    changelog = "https://github.com/cucumber-sp/yandex-music-linux/releases/tag/v5.13.2";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ shved ];
  };
}
