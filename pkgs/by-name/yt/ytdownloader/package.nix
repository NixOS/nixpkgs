{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeWrapper,
  ffmpeg-headless,
  yt-dlp,
  makeDesktopItem,
  electron,
}:

buildNpmPackage rec {
  pname = "ytDownloader";
  version = "3.19.3";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "ytDownloader";
    tag = "v${version}";
    hash = "sha256-6HYVNtjGOQICiby4je3iYG9mPGMEXWTY+87HuUMaA2A=";
  };

  npmDepsHash = "sha256-FiWtZBixg7iz/9YgqnhIIG6MYNql7ITOUXH7aBBv7Co=";
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

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  dontNpmBuild = true;

  # Patch config dir to ~/.config/ytdownloader
  # Otherwise it stores config in ~/.config/Electron
  patches = [ ./config-dir.patch ];

  # Replace hardcoded ffmpeg and ytdlp paths
  # Also stop it from downloading ytdlp
  postPatch = ''
    substituteInPlace src/renderer.js \
      --replace-fail $\{__dirname}/../ffmpeg '${lib.getExe ffmpeg-headless}' \
      --replace-fail 'path.join(os.homedir(), ".ytDownloader", "ytdlp")' '`${lib.getExe yt-dlp}`' \
      --replace-fail 'let ytDlpIsPresent = false;' 'let ytDlpIsPresent = true;'
    # Disable auto-updates
    substituteInPlace src/preferences.js \
      --replace-warn 'const autoUpdateDisabled = getId("autoUpdateDisabled");' 'const autoUpdateDisabled = "true";'
  '';

  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/ytdownloader \
        --add-flags $out/lib/node_modules/ytdownloader/main.js \
        --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}

    install -Dm444 assets/images/icon.png $out/share/pixmaps/ytdownloader.png
  '';

  meta = {
    description = "Modern GUI video and audio downloader";
    homepage = "https://github.com/aandrew-me/ytDownloader";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ chewblacka ];
    platforms = lib.platforms.all;
    mainProgram = "ytdownloader";
  };
}
