{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  aspy-refactor-imports,
  classify-imports,
}:

buildPythonPackage rec {
  pname = "reorder-python-imports";
  version = "3.12.0";
  format = "setuptools";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "reorder_python_imports";
    rev = "v${version}";
    hash = "sha256-bKv9APbraR2359IzzkzXs4sEXrTvGK3J4LO3wFHOti0=";
  };

  propagatedBuildInputs = [
    aspy-refactor-imports
    classify-imports
  ];

  pythonImportsCheck = [ "reorder_python_imports" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # prints an explanation about PYTHONPATH first
  # and therefore fails the assertion
  disabledTests = [ "test_success_messages_are_printed_on_stderr" ];

  meta = with lib; {
    description = "Tool for automatically reordering python imports";
    mainProgram = "reorder-python-imports";
    homepage = "https://github.com/asottile/reorder_python_imports";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
