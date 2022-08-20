{ lib
, stdenv
, arxiv2bib
, beautifulsoup4
, bibtexparser
, buildPythonPackage
, chardet
, click
, colorama
, configparser
, fetchFromGitHub
, filetype
, habanero
, isbnlib
, lxml
, prompt-toolkit
, pygments
, pyparsing
, pytestCheckHook
, python-doi
, python-slugify
, pythonAtLeast
, pythonOlder
, pyyaml
, requests
, stevedore
, tqdm
, typing-extensions
, whoosh
, xdg-utils
}:

buildPythonPackage rec {
  pname = "papis";
  version = "0.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-WKsU/5LXqXiFpWyTZGpvZn4lyANPosbvuhYH3opbBRs=";
  };

  propagatedBuildInputs = [
    arxiv2bib
    beautifulsoup4
    bibtexparser
    chardet
    click
    colorama
    configparser
    filetype
    habanero
    isbnlib
    lxml
    prompt-toolkit
    pygments
    pyparsing
    python-doi
    python-slugify
    pyyaml
    requests
    stevedore
    tqdm
    typing-extensions
    whoosh
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "isbnlib>=3.9.1,<3.10" "isbnlib>=3.9"
    substituteInPlace setup.cfg \
      --replace "--cov=papis" ""
  '';

  # Tests are failing on Python > 3.9
  doCheck = !stdenv.isDarwin && !(pythonAtLeast "3.10");

  checkInputs = ([
    pytestCheckHook
  ]) ++ [
    xdg-utils
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
    "papis tests"
  ];

  disabledTestPaths = [
    "tests/downloaders"
  ];

  disabledTests = [
    "get_document_url"
    "match"
    "test_doi_to_data"
    "test_downloader_getter"
    "test_general"
    "test_get_data"
    "test_validate_arxivid"
    "test_yaml"
  ];

  pythonImportsCheck = [
    "papis"
  ];

  meta = with lib; {
    description = "Powerful command-line document and bibliography manager";
    homepage = "https://papis.readthedocs.io/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nico202 teto ];
  };
}
