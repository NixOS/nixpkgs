{
  lib,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  python-dotenv,
  pythonOlder,
  setuptools,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "asana";
  version = "5.0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asana";
    repo = "python-asana";
    rev = "refs/tags/v${version}";
    hash = "sha256-X6444LU2hcx4Er5N+WbSjgbe2tHjl1y1z5FqZGngiOw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    six
    python-dateutil
    python-dotenv
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asana" ];

  disabledTestPaths = [
    # Tests require network access
    "build_tests/"
  ];

  meta = with lib; {
    description = "Python client library for Asana";
    homepage = "https://github.com/asana/python-asana";
    changelog = "https://github.com/Asana/python-asana/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
