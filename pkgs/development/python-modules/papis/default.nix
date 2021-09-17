{ lib, buildPythonPackage, fetchFromGitHub, xdg-utils
, requests, filetype, pyparsing, configparser, arxiv2bib
, pyyaml, chardet, beautifulsoup4, colorama, bibtexparser
, click, python-slugify, habanero, isbnlib, typing-extensions
, prompt-toolkit, pygments, stevedore, tqdm, lxml
, python-doi, isPy3k, pytest-cov
#, optional, dependencies
, whoosh, pytest
, stdenv
}:

buildPythonPackage rec {
  pname = "papis";
  version = "0.11.1";
  disabled = !isPy3k;

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bbkjyw1fsvvp0380l404h2lys8ib4xqga5s6401k1y1hld28nl6";
  };

  propagatedBuildInputs = [
    requests filetype pyparsing configparser arxiv2bib
    pyyaml chardet beautifulsoup4 colorama bibtexparser
    click python-slugify habanero isbnlib
    prompt-toolkit pygments typing-extensions
    stevedore tqdm lxml
    python-doi
    # optional dependencies
    whoosh
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "lxml<=4.3.5" "lxml~=4.3" \
      --replace "isbnlib>=3.9.1,<3.10" "isbnlib~=3.9" \
      --replace "python-slugify>=1.2.6,<4" "python-slugify"
  '';

  doCheck = !stdenv.isDarwin;

  checkInputs = ([
    pytest pytest-cov
  ]) ++ [
    xdg-utils
  ];

  # most of the downloader tests and 4 other tests require a network connection
  # test_export_yaml and test_citations check for the exact output produced by pyyaml 3.x and
  # fail with 5.x
  checkPhase = ''
    HOME=$(mktemp -d) pytest papis tests --ignore tests/downloaders \
      -k "not test_get_data and not test_doi_to_data and not test_general and not get_document_url \
      and not test_validate_arxivid and not test_downloader_getter and not match"
  '';

  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = "https://papis.readthedocs.io/en/latest/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ nico202 teto ];
  };
}
