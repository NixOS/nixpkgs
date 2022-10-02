{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, aspy-refactor-imports
, classify-imports
}:

buildPythonPackage rec {
  pname = "reorder-python-imports";
  version = "3.8.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "reorder_python_imports";
    rev = "v${version}";
    hash = "sha256-CLC9dfNSYqEBZB2fP34jpA/4cxm0HZzjo/e7Yn8XPFc=";
  };

  propagatedBuildInputs = [
    aspy-refactor-imports
    classify-imports
  ];

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
