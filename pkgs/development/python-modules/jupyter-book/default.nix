{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, docutils
, sphinx
, myst-nb
, click
, setuptools
, nbformat
, nbconvert
, jsonschema
, sphinx-togglebutton
, sphinx-copybutton
, sphinx-comments
, sphinxcontrib-bibtex
, sphinx-book-theme
, sphinx-thebe
, sphinx-panels
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jupyter-book";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a09311101e0cb2712ee97748f0bead732c7f6128831f68a0751700cd8467f41";
  };

  propagatedBuildInputs = [
    pyyaml
    docutils
    sphinx
    myst-nb
    click
    setuptools
    nbformat
    nbconvert
    jsonschema
    sphinx-togglebutton
    sphinx-copybutton
    sphinx-comments
    sphinxcontrib-bibtex
    sphinx-book-theme
    sphinx-thebe
    sphinx-panels
  ];

  disabled = pythonOlder "3.6";

  meta = {
    description = "Create an online book with Jupyter Notebooks";
    license = lib.licenses.bsd3;
  };
}