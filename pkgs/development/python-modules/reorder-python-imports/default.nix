{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, aspy-refactor-imports
}:

buildPythonPackage rec {
  pname = "reorder-python-imports";
  version = "3.0.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "reorder_python_imports";
    rev = "v${version}";
    sha256 = "1bdKM1sUhpZHy03DdoTzpt1iGm1t1nWnuPyTgl3KhCY=";
  };

  propagatedBuildInputs = [ aspy-refactor-imports ];

  pythonImportsCheck = [
    "reorder_python_imports"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # prints an explanation about PYTHONPATH first
  # and therefore fails the assertion
  disabledTests = [
    "test_success_messages_are_printed_on_stderr"
  ];

  meta = with lib; {
    description = "Tool for automatically reordering python imports";
    homepage = "https://github.com/asottile/reorder_python_imports";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
