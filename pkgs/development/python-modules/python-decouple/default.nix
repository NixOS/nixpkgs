{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-decouple";
  version = "3.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "HBNetwork";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-F9Gu7Y/dJhwOJi/ZaoVclF3+4U/N5JdvpXwgGB3SF3Q=";
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "decouple" ];

  meta = with lib; {
    description = "Module to handle code and condifuration";
    homepage = "https://github.com/HBNetwork/python-decouple";
    changelog = "https://github.com/HBNetwork/python-decouple/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
