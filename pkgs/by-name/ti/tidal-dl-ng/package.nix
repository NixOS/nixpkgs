{
  lib,
  python3Packages,
  fetchFromGitHub,

  replaceVars,
  ffmpeg-headless,
}:
python3Packages.buildPythonApplication rec {
  pname = "tidal-dl-ng";
  version = "0.33.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exislow";
    repo = "tidal-dl-ng";
    tag = "v${version}";
    hash = "sha256-zMozgnCy6w25WFwpKyVQiQQe6KT3arme4woOXBkSmqc=";
  };

  patches = [
    (replaceVars ./use-system-ffmpeg.patch {
      ffmpeg = lib.getExe ffmpeg-headless;
    })
  ];

  postPatch = ''
    substituteInPlace tidal_dl_ng/__init__.py \
      --replace-fail 'url: str = f"https://api.github.com/repos{repo_path}/releases/latest"' 'url = "https://api.github.com/repos/exislow/tidal-dl-ng/releases/latest"'
  '';

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    ansi2html
    coloredlogs
    dataclasses-json
    m3u8
    mpegdash
    mutagen
    pycryptodome
    python-ffmpeg
    rich
    tidalapi
    toml

    pathvalidate
    requests
    typer

    pyside6
    pyqtdarktheme
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  pythonRelaxDeps = [
    "requests"
    "rich"
    "typer"
  ];

  disabledTests = [
    "test_download_segments_cancellation"
    "test_download_segments_global_abort"
  ];

  meta = {
    description = "Multithreaded TIDAL media downloader";
    homepage = "https://github.com/exislow/tidal-dl-ng";
    changelog = "https://github.com/exislow/tidal-dl-ng/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ryand56 ];
  };
}
