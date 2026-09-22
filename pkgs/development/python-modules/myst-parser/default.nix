{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  version = "5.1.0-unstable-2026-07-12";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "myst-parser";
    rev = "e843b5ff61d9834b4864a95bf6a668909c2de3a6";
    hash = "sha256-lt2AECSVfakN63EcheYSdkHsQGl9pfcLhS9+lkMqQ7w=";
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

  disabledTestPaths = [
    # outdated sphinx fixtures
    "tests/test_renderers/test_fixtures_sphinx.py"
  ];

  pythonImportsCheck = [ "myst_parser" ];

  meta = {
    description = "Sphinx and Docutils extension to parse MyST";
    homepage = "https://myst-parser.readthedocs.io/";
    # changelog = "https://raw.githubusercontent.com/executablebooks/MyST-Parser/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
})
