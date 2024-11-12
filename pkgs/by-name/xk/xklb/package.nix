{
  lib,
  python3Packages,
  fetchFromGitHub,
  gallery-dl,
}:

python3Packages.buildPythonApplication rec {
  pname = "xklb";
  version = "3.0.024";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chapmanjacobd";
    repo = "library";
    rev = "refs/tags/v${version}";
    hash = "sha256-MGe5zwQuwWxaPd8KLRndzBlXuq/eZHOgVJfEDRCNkJU=";
  };

  # project has similar problem
  # fix https://github.com/pypa/installer/issues/194
  patches = [ ./fix-duplicate.patch ];

  prePatch = ''
    # doesn't exists in source distribution
    sed -i "/^license.=\|^readme.=/d" pyproject.toml
  '';

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    beautifulsoup4
    ffmpeg-python
    ftfy
    gallery-dl
    humanize
    ipython
    lxml
    markdown
    mutagen
    natsort
    praw
    puremagic
    pysubs2
    python-dateutil
    python-mpv-jsonipc
    regex
    rich
    screeninfo
    sqlite-utils
    tabulate
    tinytag
    yt-dlp
  ];

  optional-dependencies = with python3Packages; {
    deluxe = [
      aiohttp
      annoy
      catt
      geopandas
      pyexiftool
      pymcdm
      pyvirtualdisplay
      scikit-learn
      selenium-wire
      subliminal
      xattr
      img2pdf
      ocrmypdf
      openpyxl
      pdf2image
      pillow
      tqdm
      # not exist in nixpkgs
      # https://github.com/dleemiller/WordLlama
      # wordllama
    ];

    fat = [
      brotab
      ghostscript
      opencv-python
      orjson
      pypdf-table-extraction
      textract-py3
    ];
  };

  # lot of broken tests, need network, write, etc...
  doCheck = false;

  meta = {
    mainProgram = "library";
    description = "80+ CLI tools to build, browse, and blend your media library";
    homepage = "https://github.com/chapmanjacobd/library";
    changelog = "https://github.com/chapmanjacobd/library/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
