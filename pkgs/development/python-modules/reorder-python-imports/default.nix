{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, aspy-refactor-imports
, classify-imports
}:

buildPythonPackage rec {
  pname = "reorder-python-imports";
  version = "3.8.5";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "reorder_python_imports";
    rev = "v${version}";
    hash = "sha256-p/yhvPd2U5QSGBJFUjdy1Nmt83p8JGm2f0qKiXSjN30=";
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
