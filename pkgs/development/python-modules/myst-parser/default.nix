{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,
  defusedxml,
  docutils,
  jinja2,
  markdown-it-py,
  mdit-py-plugins,
  pyyaml,
  sphinx,
  typing-extensions,
  beautifulsoup4,
  pytest-param-files,
  pytest-regressions,
  sphinx-pytest,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "myst-parser";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "myst-parser";
    tag = "v${version}";
    hash = "sha256-/Prauz4zuJY39EK2BmgBbH1uwjF4K38e5X5hPYwRBl0=";
  };

  build-system = [ flit-core ];

  dependencies = [
    docutils
    jinja2
    mdit-py-plugins
    markdown-it-py
    pyyaml
    sphinx
    typing-extensions
  ];

  nativeCheckInputs = [
    beautifulsoup4
    defusedxml
    pytest-param-files
    pytest-regressions
    sphinx-pytest
    pytestCheckHook
  ]
  ++ markdown-it-py.optional-dependencies.linkify;

  disabledTests = [
    # sphinx 8.2 compat
    # https://github.com/executablebooks/MyST-Parser/issues/1030
    "test_sphinx_directives"
    "test_references_singlehtml"
    "test_extended_syntaxes"
    "test_fieldlist_extension"
    "test_includes"
  ];

  pythonImportsCheck = [ "myst_parser" ];

  pythonRelaxDeps = [ "docutils" ];

  meta = with lib; {
    description = "Sphinx and Docutils extension to parse MyST";
    homepage = "https://myst-parser.readthedocs.io/";
    changelog = "https://raw.githubusercontent.com/executablebooks/MyST-Parser/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
