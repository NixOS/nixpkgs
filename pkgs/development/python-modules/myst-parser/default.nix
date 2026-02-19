{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  docutils,
  jinja2,
  markdown-it-py,
  mdit-py-plugins,
  pyyaml,
  sphinx,
  typing-extensions,

  # tests
  beautifulsoup4,
  defusedxml,
  pytest-param-files,
  pytest-regressions,
  pytestCheckHook,
  sphinx-pytest,
}:
buildPythonPackage (finalAttrs: {
  pname = "myst-parser";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "myst-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Prauz4zuJY39EK2BmgBbH1uwjF4K38e5X5hPYwRBl0=";
  };

  build-system = [ flit-core ];

  pythonRelaxDeps = [
    "markdown-it-py"
  ];
  dependencies = [
    docutils
    jinja2
    markdown-it-py
    mdit-py-plugins
    pyyaml
    sphinx
    typing-extensions
  ];

  nativeCheckInputs = [
    beautifulsoup4
    defusedxml
    pytest-param-files
    pytest-regressions
    pytestCheckHook
    sphinx-pytest
  ]
  ++ markdown-it-py.optional-dependencies.linkify;

  disabledTests = [
    # sphinx 8.2 compat
    # https://github.com/executablebooks/MyST-Parser/issues/1030
    "test_commonmark"
    "test_extended_syntaxes"
    "test_fieldlist_extension"
    "test_includes"
    "test_references_singlehtml"
    "test_sphinx_directives"
  ];

  pythonImportsCheck = [ "myst_parser" ];

  meta = {
    description = "Sphinx and Docutils extension to parse MyST";
    homepage = "https://myst-parser.readthedocs.io/";
    changelog = "https://raw.githubusercontent.com/executablebooks/MyST-Parser/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
})
