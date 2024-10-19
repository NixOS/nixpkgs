{
  lib,
  python3Packages,
  fetchFromGitHub,
  yt-dlp,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "ytmdl";
  version = "2024.08.15.1";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = "ytmdl";
    rev = "refs/tags/${version}";
    hash = "sha256-q3vF7Ghr0EZfBpde4ZxggrEotX/iUK1dKRGr0uGL61Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "/etc/bash_completion.d" "share/bash-completion/completions" \
      --replace-fail "/usr/share/zsh/functions/Completion/Unix" "share/zsh/site-functions"
  '';

  dependencies = with python3Packages; [
    beautifulsoup4
    downloader-cli
    ffmpeg-python
    itunespy
    musicbrainzngs
    mutagen
    pydes
    pysocks
    pyxdg
    rich
    simber
    spotipy
    unidecode
    youtube-search-python
    yt-dlp
    ytmusicapi
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath ([ ffmpeg ])}" ];

  # This application has no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/deepjyoti30/ytmdl";
    description = "YouTube Music Downloader";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.j0hax ];
    mainProgram = "ytmdl";
  };
}
