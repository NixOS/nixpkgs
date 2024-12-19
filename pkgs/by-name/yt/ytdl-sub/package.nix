{
  python3Packages,
  fetchPypi,
  ffmpeg,
  lib,
}:
python3Packages.buildPythonApplication rec {
  pname = "ytdl-sub";
  version = "2024.12.14";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ytdl_sub";
    hash = "sha256-kCx/PlCmJesbsMv3bQ0BaTDfskP7XYE69VXdjPNfln4=";
  };

  pythonRelaxDeps = [
    "yt-dlp"
  ];

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    yt-dlp
    colorama
    mergedeep
    mediafile
    pyyaml
  ];

  makeWrapperArgs = [
    "--set YTDL_SUB_FFMPEG_PATH ${lib.getExe' ffmpeg "ffmpeg"}"
    "--set YTDL_SUB_FFPROBE_PATH ${lib.getExe' ffmpeg "ffprobe"}"
  ];

  meta = {
    homepage = "https://github.com/jmbannon/ytdl-sub";
    description = "Lightweight tool to automate downloading and metadata generation with yt-dlp";
    longDescription = ''
      ytdl-sub is a command-line tool that downloads media via yt-dlp and prepares it for your favorite media player, including Kodi, Jellyfin, Plex, Emby, and modern music players. No additional plugins or external scrapers are needed.
    '';
    changelog = "https://github.com/jmbannon/ytdl-sub/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      loc
    ];
    mainProgram = "ytdl-sub";
  };
}
