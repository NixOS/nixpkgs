{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pytest-html,
  pyyaml,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "8.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cucumber";
    repo = "tag-expressions";
    tag = "v${version}";
    hash = "sha256-3uePEu+4StDP2IV3u/AUZLxxbVVegW7ZSUllWnXU8w0=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-html
    pyyaml
  ];

  meta = {
    homepage = "https://github.com/cucumber/tag-expressions";
    description = "Provides tag-expression parser for cucumber/behave";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxxk ];
  };
}
