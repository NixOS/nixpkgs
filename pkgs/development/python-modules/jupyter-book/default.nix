{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
, pythonRelaxDepsHook
, click
, docutils
, jinja2
, jsonschema
, linkify-it-py
, myst-nb
, pyyaml
, sphinx
, sphinx-comments
, sphinx-copybutton
, sphinx-external-toc
, sphinx-jupyterbook-latex
, sphinx-design
, sphinx-thebe
, sphinx-book-theme
, sphinx-togglebutton
, sphinxcontrib-bibtex
, sphinx-multitoc-numbering
}:

buildPythonPackage rec {
  pname = "jupyter-book";
  version = "0.15.0";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eUw3zC+6kx/OQvMhzkG6R3b2ricX0kvC+fCBD4mkEuo=";
  };

  nativeBuildInputs = [
    flit-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    click
    docutils
    jinja2
    jsonschema
    linkify-it-py
    myst-nb
    pyyaml
    sphinx
    sphinx-comments
    sphinx-copybutton
    sphinx-external-toc
    sphinx-jupyterbook-latex
    sphinx-design
    sphinx-thebe
    sphinx-book-theme
    sphinx-togglebutton
    sphinxcontrib-bibtex
    sphinx-multitoc-numbering
  ];

  pythonRelaxDeps = [
    "docutils"
  ];

  pythonImportsCheck = [
    "jupyter_book"
  ];

  meta = with lib; {
    description = "Build a book with Jupyter Notebooks and Sphinx";
    homepage = "https://jupyterbook.org/";
    changelog = "https://github.com/executablebooks/jupyter-book/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
