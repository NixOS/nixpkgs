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
, dominate
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
}:

buildPythonPackage rec {
  pname = "papis";
  version = "0.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iRrf37hq+9D01JRaQIqg7yTPbLX6I0ZGnzG3r1DX464=";
  };

  propagatedBuildInputs = [
    arxiv2bib
    beautifulsoup4
    bibtexparser
    chardet
    click
    colorama
    configparser
    dominate
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
    substituteInPlace setup.cfg \
      --replace "--cov=papis" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
    "papis tests"
  ];

  disabledTestPaths = [
    "tests/downloaders"
    "papis/downloaders/usenix.py"
  ];

  disabledTests = [
    "get_document_url"
    "match"
    "test_doi_to_data"
    "test_downloader_getter"
    "test_general"
    "test_get_config_dirs"
    "test_get_configuration"
    "test_get_data"
    "test_valid_dblp_key"
    "test_validate_arxivid"
    "test_yaml"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_default_opener"
  ];

  pythonImportsCheck = [
    "papis"
  ];

  meta = with lib; {
    description = "Powerful command-line document and bibliography manager";
    mainProgram = "papis";
    homepage = "https://papis.readthedocs.io/";
    changelog = "https://github.com/papis/papis/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nico202 teto marsam ];
  };
}
