{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  typing-extensions,
  numpy,
  numpy-typing-compat,
  beartype,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage {
  pname = "optype";
  version = "0.14.0-unstable-2025-11-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorenham";
    repo = "optype";
    rev = "5f16def3546222caf81a3411a27b007a00819172";
    hash = "sha256-52cY+u0wjhJFQDLsjND/h6cfln4rCTtcy+HqaoH/re0=";
  };

  disabled = pythonOlder "3.11";

  build-system = [
    uv-build
  ];

  dependencies = [
    typing-extensions
  ];

  optional-dependencies = {
    numpy = [
      numpy
      numpy-typing-compat
    ];
  };

  pythonImportsCheck = [
    "optype"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    numpy-typing-compat
    beartype
  ];

  meta = {
    description = "Opinionated typing package for precise type hints in Python";
    homepage = "https://github.com/jorenham/optype";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jolars ];
  };
}
