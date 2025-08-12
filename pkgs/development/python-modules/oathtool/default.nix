{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  autocommand,
  importlib-resources,
  path,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oathtool";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "oathtool";
    tag = "v${version}";
    hash = "sha256-Qa4/fVa7Ws8t42MxZpEVKI7Wyux/uN77VP0JBnrmgq0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    autocommand
    path
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oathtool" ];

  meta = {
    description = "One-time password generator";
    homepage = "https://github.com/jaraco/oathtool";
    changelog = "https://github.com/jaraco/oathtool/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
