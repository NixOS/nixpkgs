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
  version = "0.15.1";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ihY07Bb37t7g0Rbx5ft8SCAyia2S2kLglRnccdlWwBA=";
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
    "sphinx-design"
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
