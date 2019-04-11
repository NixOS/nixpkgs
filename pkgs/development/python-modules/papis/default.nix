{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, xdg_utils
, requests, filetype, pyparsing, configparser, arxiv2bib
, pyyaml, chardet, beautifulsoup4, colorama, bibtexparser
, pylibgen, click, python-slugify, habanero, isbnlib
, prompt_toolkit, pygments
#, optional, dependencies
, jinja2, whoosh, pytest
}:

buildPythonPackage rec {
  pname = "papis";
  version = "0.8.2";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sa4hpgjvqkjcmp9bjr27b5m5jg4pfspdc8nf1ny80sr0kzn72hb";
  };

  propagatedBuildInputs = [
    requests filetype pyparsing configparser arxiv2bib
    pyyaml chardet beautifulsoup4 colorama bibtexparser
    pylibgen click python-slugify habanero isbnlib
    prompt_toolkit pygments
    # optional dependencies
    jinja2 whoosh
  ];

  checkInputs = ([
    pytest
  ]) ++ [
    xdg_utils
  ];

  # most of the downloader tests and 4 other tests require a network connection
  checkPhase = ''
    HOME=$(mktemp -d) pytest papis tests --ignore tests/downloaders \
      -k "not test_get_data and not test_doi_to_data and not test_general and not get_document_url"
  '';

  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = http://papis.readthedocs.io/en/latest/;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ nico202 teto ];
  };
}
