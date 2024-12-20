{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  flit-core,

  # dependencies
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

  # tests
  jupytext,
  pytest-regressions,
  pytest-xdist,
  pytestCheckHook,
  sphinx-inline-tabs,
  texsoup,
}:

buildPythonPackage rec {
  pname = "jupyter-book";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jupyter-book";
    repo = "jupyter-book";
    rev = "refs/tags/v${version}";
    hash = "sha256-MBSf2/+4+efWHJ530jdezeh5OLTtUZlAEOl5SqoWOuE=";
  };

  build-system = [ flit-core ];

  pythonRelaxDeps = [ "myst-parser" ];

  dependencies = [
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

  nativeCheckInputs = [
    jupytext
    pytest-regressions
    pytest-xdist
    pytestCheckHook
    sphinx-inline-tabs
    texsoup
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # touch the network
    "test_create_from_cookiecutter"
    # flaky?
    "test_execution_timeout"
    # require texlive
    "test_toc"
    "test_toc_latex_parts"
    "test_toc_latex_urllink"
    # WARNING: Executing notebook failed: CellExecutionError [mystnb.exec]
    "test_build_dirhtml_from_template"
    "test_build_from_template"
    "test_build_page"
    "test_build_singlehtml_from_template"
  ];

  disabledTestPaths = [
    # require texlive
    "tests/test_pdf.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Build a book with Jupyter Notebooks and Sphinx";
    homepage = "https://jupyterbook.org/";
    changelog = "https://github.com/jupyter-book/jupyter-book/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
    mainProgram = "jupyter-book";
  };
}
