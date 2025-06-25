{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  defusedxml,
  docutils,
  fetchFromGitHub,
  flit-core,
  jinja2,
  markdown-it-py,
  mdit-py-plugins,
  pytest-param-files,
  pytest-regressions,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  sphinx-pytest,
  sphinx,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "myst-docutils";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "MyST-Parser";
    tag = "v${version}";
    hash = "sha256-/Prauz4zuJY39EK2BmgBbH1uwjF4K38e5X5hPYwRBl0=";
  };

  build-system = [ flit-core ];

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
  ];

  pythonImportsCheck = [ "myst_parser" ];

  disabledTests = [
    # Tests require linkify
    "test_cmdline"
    "test_extended_syntaxes"
    # sphinx compat
    "test_sphinx_directives"
  ];

  disabledTestPaths = [
    # Assertion errors
    "tests/test_sphinx/"
  ];

  meta = with lib; {
    description = "Extended commonmark compliant parser, with bridges to docutils/sphinx";
    homepage = "https://github.com/executablebooks/MyST-Parser";
    changelog = "https://github.com/executablebooks/MyST-Parser/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dpausp ];
  };
}
