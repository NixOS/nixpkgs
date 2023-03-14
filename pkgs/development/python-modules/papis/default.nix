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
    # Remove when https://github.com/papis/papis/pull/478 lands in upstream
    substituteInPlace setup.py \
      --replace "etc/bash_completion.d/" "share/bash-completion/completions/"
    substituteInPlace setup.cfg \
      --replace "--cov=papis" ""
  '';

  checkInputs = [
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
  ] ++ lib.optionals stdenv.isDarwin [
    "test_default_opener"
  ];

  pythonImportsCheck = [
    "papis"
  ];

  meta = with lib; {
    description = "Powerful command-line document and bibliography manager";
    homepage = "https://papis.readthedocs.io/";
    changelog = "https://github.com/papis/papis/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nico202 teto marsam ];
  };
}
