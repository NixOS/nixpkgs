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
  version = "1.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "mandown";
    tag = "v${version}";
    hash = "sha256-xoRUGtZMM1l3gCtF1wFHBo3vTEGJcNxqkO/yeTuEke8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [
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
