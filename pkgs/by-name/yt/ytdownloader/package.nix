{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, ffmpeg
, yt-dlp
, makeDesktopItem
, electron
}:

buildNpmPackage rec {
  pname = "ytDownloader";
  version = "3.17.4";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "ytDownloader";
    rev = "refs/tags/v${version}";
    hash = "sha256-GW+17DfPiFxw2QyJ5KTMZLDWmqXfnHfkg+QpM5XOP0M=";
  };

  npmDepsHash = "sha256-lhFyiWy9dgnxxaElavzqA4YpRm7cVC23pvL5Kwve58E=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ffmpeg yt-dlp ];

  desktopItem = makeDesktopItem {
    name = "ytDownloader";
    exec = "ytdownloader %U";
    icon = "ytdownloader";
    desktopName = "ytDownloader";
    comment = "A modern GUI video and audio downloader";
    categories = [ "Utility" ];
    startupWMClass = "ytDownloader";
  };

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  dontNpmBuild = true;

  # Patch config dir to ~/.config/ytdownloader
  # Otherwise it stores config in ~/.config/Electron
  patches = [ ./config-dir.patch ];

  # Replace hardcoded ffmpeg and ytdlp paths
  # Also stop it from downloading ytdlp
  postPatch = ''
    substituteInPlace src/renderer.js \
      --replace-fail $\{__dirname}/../ffmpeg '${lib.getExe ffmpeg}' \
      --replace-fail 'path.join(os.homedir(), ".ytDownloader", "ytdlp")' '`${lib.getExe yt-dlp}`' \
      --replace-fail '!!localStorage.getItem("fullYtdlpBinPresent")' 'true'
  '';

  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/ytdownloader \
        --add-flags $out/lib/node_modules/ytdownloader/main.js

    install -Dm444 assets/images/icon.png $out/share/pixmaps/ytdownloader.png
    install -Dm444 "${desktopItem}/share/applications/"* -t $out/share/applications
  '';

  meta = {
    description = "A modern GUI video and audio downloader";
    homepage = "https://github.com/aandrew-me/ytDownloader";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ chewblacka ];
    platforms = lib.platforms.all;
    mainProgram = "ytdownloader";
  };
}
