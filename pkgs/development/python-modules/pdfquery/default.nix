{
  buildPythonPackage,
  fetchPypi,
  lib,
  cssselect,
  chardet,
  lxml,
  pdfminer-six,
  pyquery,
  roman,
  six,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pdfquery";
  version = "0.4.3";
  pyproject = true;

  # The latest version is on PyPI but not tagged on GitHub
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oqKXTLMS/aT1aa3I1jN30l1cY2ckC0p7+xZTksc+Hc4=";
  };

  dependencies = [
    cssselect
    chardet
    lxml
    pdfminer-six
    pyquery
    roman

    # Not explicitly listed in setup.py; found through trial and error
    six
  ];

  build-system = [
    setuptools
  ];

  # Although this package has tests, they aren't runnable with
  # `unittestCheckHook` or `pytestCheckHook` because you're meant
  # to run the tests with `python setup.py test`, but that's deprecated
  # and doesn't work anymore. So there are no runnable tests.
  doCheck = false;

  # This runs as a different phase than checkPhase, so still runs
  # despite `doCheck = false`
  pythonImportsCheck = [
    "pdfquery"
  ];

  meta = {
    description = "Concise, friendly PDF scraping using JQuery or XPath syntax";
    homepage = "https://github.com/jcushman/pdfquery";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.samasaur ];
  };
}
