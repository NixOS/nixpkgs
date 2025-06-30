{
  lib,
  buildPythonPackage,
  isPyPy,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "3.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pyflakes";
    rev = version;
    hash = "sha256-nNug9EZ0coI095/QJu/eK1Ozlt01INT+mLlYdqrJuzE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals isPyPy [
    # https://github.com/PyCQA/pyflakes/issues/779
    "test_eofSyntaxError"
    "test_misencodedFileUTF8"
    "test_multilineSyntaxError"
    "test_misencodedFileUTF16"
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
