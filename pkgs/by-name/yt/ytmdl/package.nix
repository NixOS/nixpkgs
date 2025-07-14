{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "ytmdl";
  version = "2023.11.26";
  pyproject = true;

  src = fetchPypi {
    inherit pname;
    version = builtins.replaceStrings [ ".0" ] [ "." ] version;
    hash = "sha256-Im3rQAs/TYookv6FeGpU6tJxUGBMb6/UW1ZMDg9FW4s=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "/etc/bash_completion.d" "share/bash-completion/completions" \
      --replace-fail "/usr/share/zsh/functions/Completion/Unix" "share/zsh/site-functions"
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    ffmpeg-python
    musicbrainzngs
    rich
    simber
    pydes
    youtube-search-python
    unidecode
    pyxdg
    downloader-cli
    beautifulsoup4
    itunespy
    mutagen
    pysocks
    yt-dlp
    ytmusicapi
    spotipy
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook # the app tries to log stuff into xdg_cache_home
  ];

  pythonImportsCheck = [ "ytmdl" ];

  meta = with lib; {
    homepage = "https://github.com/deepjyoti30/ytmdl";
    description = "YouTube Music Downloader";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
    mainProgram = "ytmdl";
  };
}
