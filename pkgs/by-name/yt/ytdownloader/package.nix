{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeWrapper,
  ffmpeg-headless,
  yt-dlp,
  makeDesktopItem,
  electron_43,
}:
let
  electron = electron_43;
in
buildNpmPackage rec {
  pname = "ytDownloader";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "ytDownloader";
    tag = "v${version}";
    hash = "sha256-chTaQ0nHTtdIhMo4GBSoQ6YbqDy8HNj190JNUt5nDiE=";
  };

  npmDepsHash = "sha256-Czs09QnQ7lnNjgysvSb7TFKz6t8ChvoT+1KzHFJ87SA=";
  makeCacheWritable = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];
  buildInputs = [
    ffmpeg-headless
    yt-dlp
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ytDownloader";
      exec = "ytdownloader %U";
      icon = "ytdownloader";
      desktopName = "ytDownloader";
      comment = "A modern GUI video and audio downloader";
      categories = [ "Utility" ];
      startupWMClass = "ytDownloader";
    })
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  dontNpmBuild = true;

  # Patch config dir to ~/.config/ytdownloader
  # Otherwise it stores config in ~/.config/Electron
  patches = [ ./config-dir.patch ];

  postPatch = ''
    # Disable auto-updates
    substituteInPlace src/preferences.js \
      --replace-warn 'const autoUpdateDisabled = getId("autoUpdateDisabled");' 'const autoUpdateDisabled = "true";'
  '';

  postInstall = ''
    # Set paths to use system ffmpeg and yt-dlp to prevent downloading
    makeWrapper ${electron}/bin/electron $out/bin/ytdownloader \
        --add-flags $out/lib/node_modules/ytdownloader/main.js \
        --set YTDOWNLOADER_FFMPEG_PATH "${lib.getExe ffmpeg-headless}" \
        --set YTDOWNLOADER_YTDLP_PATH "${lib.getExe yt-dlp}" \
        --prefix PATH : ${
          lib.makeBinPath [
            ffmpeg-headless
            yt-dlp
          ]
        }

    install -Dm444 assets/images/icon.png $out/share/icons/hicolor/512x512/apps/ytdownloader.png
  '';

  meta = {
    description = "Modern GUI video and audio downloader";
    homepage = "https://github.com/aandrew-me/ytDownloader";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "ytdownloader";
  };
}
