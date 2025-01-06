{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  beautifulsoup4,
  comicon,
  feedparser,
  filetype,
  lxml,
  natsort,
  nix-update-script,
  pillow,
  python-slugify,
  requests,
  typer,
  pyside6,
}:

buildPythonPackage rec {
  pname = "mandown";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "mandown";
    rev = "refs/tags/v${version}";
    hash = "sha256-eMZXXOGe9jKf9bXEinIIu6w3i4SOkLnDWnxmT5G0RWA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "lxml"
    "pillow"
    "typer"
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    comicon
    feedparser
    filetype
    lxml
    natsort
    pillow
    python-slugify
    requests
    typer
  ];

  optional-dependencies = {
    gui = [ pyside6 ];
    updateScript = nix-update-script { };
  };

  pythonImportsCheck = [ "mandown" ];

  meta = with lib; {
    changelog = "https://github.com/potatoeggy/mandown/releases/tag/v${version}";
    description = "Comic/manga/webtoon downloader and CBZ/EPUB/MOBI/PDF converter";
    homepage = "https://github.com/potatoeggy/mandown";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
