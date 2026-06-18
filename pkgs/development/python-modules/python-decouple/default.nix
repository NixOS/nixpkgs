{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-decouple";
  version = "3.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HBNetwork";
    repo = "python-decouple";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F9Gu7Y/dJhwOJi/ZaoVclF3+4U/N5JdvpXwgGB3SF3Q=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "decouple" ];

  meta = {
    description = "Module to handle code and condifuration";
    homepage = "https://github.com/HBNetwork/python-decouple";
    changelog = "https://github.com/HBNetwork/python-decouple/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
