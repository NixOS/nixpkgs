{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pywikibot";
  version = "8.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OARU5rblOnT0kl0a+u2bSFMl+mL41HXrOTGluDoeABU=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    mwparserfromhell
    requests
    setuptools
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    create_isbn_edition.py = [
      isbnlib
      unidecode
    ];
    eventstreams = [
      sseclient
    ];
    flake8 = [
      darglint
      flake8
      flake8-bugbear
      flake8-coding
      flake8-comprehensions
      flake8-docstrings
      flake8-mock-x2
      flake8-no-u-prefixed-strings
      flake8-print
      flake8-quotes
      flake8-string-format
      flake8-tuple
      pep8-naming
      pydocstyle
    ];
    google = [
      google
    ];
    graphviz = [
      pydot
    ];
    hacking = [
      hacking
    ];
    html = [
      beautifulsoup4
    ];
    http = [
      fake-useragent
    ];
    isbn = [
      python-stdnum
    ];
    memento = [
      memento-client
    ];
    mwoauth = [
      mwoauth
    ];
    mysql = [
      pymysql
    ];
    scripts = [
      isbnlib
      memento-client
      unidecode
    ];
    tkinter = [
      pillow
    ];
    weblinkchecker.py = [
      memento-client
    ];
    wikitextparser = [
      wikitextparser
    ];
  };

  pythonImportsCheck = [ "pywikibot" ];

  meta = with lib; {
    description = "Python MediaWiki Bot Framework";
    homepage = "https://pypi.org/project/pywikibot";
    license = licenses.mit;
    maintainers = with maintainers; [ TheBrainScrambler ];
    mainProgram = "pwb";
  };
}
