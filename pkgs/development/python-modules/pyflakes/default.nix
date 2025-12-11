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
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pyflakes";
    tag = version;
    hash = "sha256-4UEJjn9Eey1vHeaG468x/nMlbfGu3ohZX1R7RR2R5ik=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals isPyPy [
    # https://github.com/PyCQA/pyflakes/issues/779
    "test_eofSyntaxError"
    "test_misencodedFileUTF16"
    "test_misencodedFileUTF8"
    "test_multilineSyntaxError"
  ];

  pythonImportsCheck = [ "pyflakes" ];

  meta = {
    homepage = "https://github.com/PyCQA/pyflakes";
    changelog = "https://github.com/PyCQA/pyflakes/blob/${src.tag}/NEWS.rst";
    description = "Simple program which checks Python source files for errors";
    mainProgram = "pyflakes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
