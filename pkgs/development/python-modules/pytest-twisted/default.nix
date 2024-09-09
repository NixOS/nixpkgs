{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  greenlet,
  pytest,
  decorator,
  twisted,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-twisted";
  version = "1.14.2-unstable-2024-08-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-twisted";
    rev = "0f10b1500aa6c46a2b206abc690a4e00e3c7556b";
    hash = "sha256-1dAfCa6hON0Vh9StI1Xw69IAwBzUkR6DdjQ0HNyoyME=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [
    decorator
    greenlet
  ];

  nativeCheckInputs = [
    pytestCheckHook
    twisted
  ];

  pythonImportsCheck = [ "pytest_twisted" ];

  meta = with lib; {
    changelog = "https://github.com/pytest-dev/pytest-twisted/releases/tag/v${version}";
    description = "Twisted plugin for py.test";
    homepage = "https://github.com/pytest-dev/pytest-twisted";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
