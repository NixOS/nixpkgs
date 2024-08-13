{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  click,
  colorama,
  git,
  jinja2,
  jsonref,
  jsonschema,
  pexpect,
  pydantic,
  pydantic-core,
  pydantic-settings,
  pyparsing,
  pytest,
  pytestCheckHook,
  pytest-cov,
  pytest-mock,
  pyyaml,
  requests,
  requests-file,
  requests-mock,
  requests-toolbelt,
  sphinx,
  sphinxHook,
  sphinx-click,
  sphinx-collapse,
  sphinx-copybutton,
  sphinx-rtd-theme,
  sphinx-tabs,
  stdenv,
  tqdm,
  typing-extensions,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "idf-component-manager";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "idf-component-manager";
    rev = "v${version}";
    hash = "sha256-kfUIy+xjbHoZjMNFWfgwe+84TEvY8905tJSDUJn50Gs=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    click
    colorama
    jsonref
    pydantic
    pydantic-core
    pydantic-settings
    pyparsing
    pyyaml
    requests
    requests-file
    requests-toolbelt
    tqdm
    typing-extensions
  ];

  sphinxRoot = "docs/en";
  nativeBuildInputs = [
    sphinx
    sphinxHook
    sphinx-click
    sphinx-collapse
    sphinx-copybutton
    sphinx-rtd-theme
    sphinx-tabs
  ];

  checkInputs = [
    jinja2
    jsonschema
    pexpect
    pytest
    pytest-cov
    pytest-mock
    requests-mock
    vcrpy
  ];

  nativeCheckInputs = lib.optionals stdenv.isLinux [
    git
    pytestCheckHook
  ];

  preCheck = "export XDG_CACHE_HOME=$(mktemp -d)";
  # Tries to get https://components.espressif.com/api/tokens/current
  disabledTests = [ "test_no_registry_token_error" ];
  # bin/compote is not yet in PATH
  disabledTestPaths = [ "tests/cli/test_compote.py" ];

  pythonImportsCheck = [ "idf_component_manager" ];

  meta = {
    description = "Tool for installing ESP-IDF components";
    homepage = "https://github.com/espressif/idf-component-manager";
    changelog = "https://github.com/espressif/idf-component-manager/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "compote";
  };
}
