{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, snowballstemmer
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pydocstyle";
  version = "6.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    hash = "sha256-j0WMD2qKDdMaKG2FxrrM/O7zX4waJ1afaRPRv70djkE=";
  };

  propagatedBuildInputs = [
    snowballstemmer
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "src/tests/test_integration.py" # runs pip install
  ];

  pythonImportsCheck = [
    "pydocstyle"
  ];

  meta = with lib; {
    description = "Python docstring style checker";
    homepage = "https://github.com/PyCQA/pydocstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ dzabraev ];
  };
}
