{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit-core,
  click,
  jinja2,
  jsonschema,
  linkify-it-py,
  myst-nb,
  myst-parser,
  pyyaml,
  sphinx,
  sphinx-comments,
  sphinx-copybutton,
  sphinx-external-toc,
  sphinx-jupyterbook-latex,
  sphinx-design,
  sphinx-thebe,
  sphinx-book-theme,
  sphinx-togglebutton,
  sphinxcontrib-bibtex,
  sphinx-multitoc-numbering,
}:

buildPythonPackage rec {
  pname = "jupyter-book";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_book";
    hash = "sha256-rRXuSanf7Hc6HTBJ2sOFY4KqL5txRKGAEUduZcEbX0Y=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    click
    jinja2
    jsonschema
    linkify-it-py
    myst-nb
    myst-parser
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

  pythonImportsCheck = [
    "jupyter_book"
    "jupyter_book.cli.main"
  ];

  meta = with lib; {
    description = "Build a book with Jupyter Notebooks and Sphinx";
    homepage = "https://jupyterbook.org/";
    changelog = "https://github.com/executablebooks/jupyter-book/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "jupyter-book";
  };
}
