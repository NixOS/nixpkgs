{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  fetchNpmDeps,

  # build-system
  hatch-deps-selector,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,

  # nativeBuildInputs
  nodejs,
  npmHooks,

  # dependencies
  jupyter-core,
  jupyter-server,
  ipykernel,
  nodeenv,

  # tests
  versionCheckHook,
=======

  # build-system
  hatchling,

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
  writableTmpDirAsHomeHook,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "jupyter-book";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "1.0.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-book";
    repo = "jupyter-book";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Wh3ggKbV0mmcIbpIMsF09UH9ZyVOgpYAx4ppTSUHIKo=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-oNTVzpjDb4bXIpuZcO/6f82UfOVxbkMMluwOKaNM5tE=";
  };

  build-system = [
    hatch-deps-selector
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
  ];

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  # jupyter-book requires node at runtime
  propagatedBuildInputs = [
    nodejs
  ];

  dependencies = [
    ipykernel
    jupyter-core
    jupyter-server
    nodeenv
  ];

  pythonImportsCheck = [ "jupyter_book" ];

  # No python tests
  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
=======
    hash = "sha256-04I9mzJMXCpvMiOeMD/Bg8FiymkRgHf/Yo9C1VcyTsw=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "myst-parser"
    "sphinx"
  ];

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
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # touch the network
    "test_create_from_cookiecutter"

    # flaky?
    "test_execution_timeout"

    # require texlive
    "test_toc"
    "test_toc_latex_parts"
    "test_toc_latex_urllink"

    # AssertionError: assert 'There was an error in building your book' in '1'
    "test_build_errors"

    # WARNING: Executing notebook failed: CellExecutionError [mystnb.exec]
    "test_build_dirhtml_from_template"
    "test_build_from_template"
    "test_build_page"
    "test_build_singlehtml_from_template"

    # pytest.PytestUnraisableExceptionWarning: Exception ignored in: <sqlite3.Connection object at 0x115dcc9a0>
    # ResourceWarning: unclosed database in <sqlite3.Connection object at 0x115dcc9a0>
    "test_clean_book"
    "test_clean_html"
    "test_clean_html_latex"
    "test_clean_latex"
  ];

  disabledTestPaths = [
    # require texlive
    "tests/test_pdf.py"
  ];

  __darwinAllowLocalNetworking = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Build a book with Jupyter Notebooks and Sphinx";
    homepage = "https://jupyterbook.org/";
    changelog = "https://github.com/jupyter-book/jupyter-book/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-book";
  };
}
