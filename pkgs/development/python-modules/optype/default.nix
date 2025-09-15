{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  typing-extensions,
  numpy,
  beartype,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "optype";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorenham";
    repo = "optype";
    tag = "v${version}";
    hash = "sha256-GhG2TR5FJgEXBXLyGTNQKFYtR2iZ0tLgZ9B0YL8SXu8=";
  };

  disabled = pythonOlder "3.11";

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  optional-dependencies = {
    numpy = [
      numpy
    ];
  };

  pythonImportsCheck = [
    "optype"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    beartype
  ];

  meta = {
    description = "Opinionated typing package for precise type hints in Python";
    homepage = "https://github.com/jorenham/optype";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jolars ];
  };
}
