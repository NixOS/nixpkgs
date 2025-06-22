{
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
  lib,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "ytdl-sub";
  version = "2025.06.19.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmbannon";
    repo = "ytdl-sub";
    tag = version;
    hash = "sha256-aZ7LzpOZgI9KUt0aWMdzVH299O83d3zPxldRKZvwO8I=";
  };

  postPatch = ''
    echo '__pypi_version__ = "${version}"; __local_version__ = "${version}"' > src/ytdl_sub/__init__.py
  '';

  pythonRelaxDeps = [ "yt-dlp" ];

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

  nativeCheckInputs = [
    versionCheckHook
    python3Packages.pytestCheckHook
  ];
  versionCheckProgramArg = "--version";

  env = {
    YTDL_SUB_FFMPEG_PATH = "${lib.getExe' ffmpeg "ffmpeg"}";
    YTDL_SUB_FFPROBE_PATH = "${lib.getExe' ffmpeg "ffprobe"}";
  };

  disabledTests = [
    "test_logger_can_be_cleaned_during_execution"
    "test_presets_run"
    "test_thumbnail"
  ];

  pytestFlagsArray = [
    # According to documentation, e2e tests can be flaky:
    # "This checksum can be inaccurate for end-to-end tests"
    "--ignore=tests/e2e"
  ];

  passthru.updateScript = ./update.sh;

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
      defelo
    ];
    mainProgram = "ytdl-sub";
  };
}
