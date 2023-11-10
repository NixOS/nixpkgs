{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
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
  version = "1.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "mandown";
    rev = "refs/tags/v${version}";
    hash = "sha256-2kFzB1xLVEvO7Vo39lwQsVirRY6Z8GMczWK2b1oVYTg=";
  };

  nativeBuildInputs = [
    poetry-core
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

  postPatch = ''
    substituteInPlace pyproject.toml --replace 'typer = "^0.7.0"' 'typer = "^0"'
  '';

  pythonImportsCheck = [ "mandown" ];

  meta = with lib; {
    description = "Comic/manga/webtoon downloader and CBZ/EPUB/MOBI/PDF converter";
    homepage = "https://github.com/potatoeggy/mandown";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
