{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonRelaxDepsHook
, beautifulsoup4
, comicon
, feedparser
, filetype
, lxml
, natsort
, pillow
, python-slugify
, requests
, typer
, pyside6
}:

buildPythonPackage rec {
  pname = "mandown";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "mandown";
    rev = "refs/tags/v${version}";
    hash = "sha256-oHa7/2fv+BG5KIKFIICYBqddub5SokDvAI6frbVwGSo=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
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

  passthru.optional-dependencies = {
    gui = [
      pyside6
    ];
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
