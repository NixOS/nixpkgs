{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-decouple";
  version = "3.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "HBNetwork";
    repo = "python-decouple";
    tag = "v${version}";
    hash = "sha256-F9Gu7Y/dJhwOJi/ZaoVclF3+4U/N5JdvpXwgGB3SF3Q=";
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "decouple" ];

  meta = {
    description = "Module to handle code and condifuration";
    homepage = "https://github.com/HBNetwork/python-decouple";
    changelog = "https://github.com/HBNetwork/python-decouple/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
