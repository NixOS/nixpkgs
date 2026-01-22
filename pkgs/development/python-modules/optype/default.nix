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

buildPythonPackage (finalAttrs: {
  pname = "optype";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorenham";
    repo = "optype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tzbS+CeWGxMXK1LFN/LslI6kfbVQPjqYlDB7fX0ogfU=";
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
})
