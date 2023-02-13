{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, snowballstemmer
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pydocstyle";
  version = "6.1.1";
  disabled = !isPy3k;

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "sha256-j0WMD2qKDdMaKG2FxrrM/O7zX4waJ1afaRPRv70djkE=";
  };

  propagatedBuildInputs = [
    snowballstemmer
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "src/tests/test_integration.py" # runs pip install
  ];

  meta = with lib; {
    description = "Python docstring style checker";
    homepage = "https://github.com/PyCQA/pydocstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ dzabraev ];
  };
}
