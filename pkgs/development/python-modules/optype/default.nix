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
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorenham";
    repo = "optype";
    tag = "v${version}";
    hash = "sha256-jExwQiEkCLiVFwiFYp2dBvH5PiRlSVG20CneGnht+No=";
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
