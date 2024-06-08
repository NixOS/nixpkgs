{
  lib,
  buildPythonPackage,
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

  pythonImportsCheck = [ "pyflakes" ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/pyflakes";
    changelog = "https://github.com/PyCQA/pyflakes/blob/${src.rev}/NEWS.rst";
    description = "A simple program which checks Python source files for errors";
    mainProgram = "pyflakes";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
