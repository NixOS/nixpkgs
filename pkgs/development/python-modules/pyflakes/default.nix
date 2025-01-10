{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "3.2.0";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pyflakes";
    rev = version;
    hash = "sha256-ouCkkm9OrYob00uLTilqgWsTWfHhzaiZp7sa2C5liqk=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/PyCQA/pyflakes/issues/812
    "test_errors_syntax"
  ];

  pythonImportsCheck = [ "pyflakes" ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/pyflakes";
    changelog = "https://github.com/PyCQA/pyflakes/blob/${src.rev}/NEWS.rst";
    description = "Simple program which checks Python source files for errors";
    mainProgram = "pyflakes";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
