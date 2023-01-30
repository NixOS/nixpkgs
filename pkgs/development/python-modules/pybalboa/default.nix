{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pybalboa";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "garbled1";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-08FMNRArzmfmLH6y5Z8QPcRVZJIvU3VIOvdTry3iBGI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "pybalboa"
  ];

  disabledTestPaths = [
    # Test requires server instance
    "tests/test_client.py"
  ];

  meta = with lib; {
    description = "Module to interface with a Balboa Spa";
    homepage = "https://github.com/garbled1/pybalboa";
    changelog = "https://github.com/garbled1/pybalboa/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
