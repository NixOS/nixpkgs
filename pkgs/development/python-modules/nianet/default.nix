{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  niapy,
  numpy,
  scikit-learn,
  torch,

  # tests
  pytestCheckHook,
  pyyaml,
  tomli,
}:

buildPythonPackage (finalAttrs: {
  pname = "nianet";
  version = "1.1.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SasoPavlic";
    repo = "nianet";
    tag = "version_${finalAttrs.version}";
    hash = "sha256-FZipl6Z9AfiL6WH0kvUn8bVxt8JLdDVlmTSqnyxe0nY=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "numpy"
    "torch"
  ];
  dependencies = [
    niapy
    numpy
    scikit-learn
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    tomli
  ];

  pythonImportsCheck = [ "nianet" ];

  meta = {
    description = "Designing and constructing neural network topologies using nature-inspired algorithms";
    homepage = "https://github.com/SasoPavlic/NiaNet";
    changelog = "https://github.com/SasoPavlic/NiaNet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
})
