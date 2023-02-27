{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, snowballstemmer
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pydocstyle";
  version = "6.3.0";
  disabled = !isPy3k;

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-MjRrnWu18f75OjsYIlOLJK437X3eXnlW8WkkX7vdS6k=";
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
