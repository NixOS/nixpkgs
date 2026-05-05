{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  boto3,
  filelock,
  lightning-utilities,
  numpy,
  obstore,
  requests,
  tifffile,
  torch,
  torchvision,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "litdata";
  version = "0.2.61";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "litdata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rPBDEwOiKbT1cm3PEEbsCw9CgKtbk2isEbGbkmQw/B4=";
  };

  # missing __init__.py otherwise prevents importing litdata.cli.handler:
  postPatch = "touch src/litdata/cli/handler/__init__.py";

  build-system = [
    setuptools
  ];

  dependencies = [
    boto3
    filelock
    lightning-utilities
    numpy
    obstore
    requests
    tifffile
    torch
    torchvision
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "litdata"
    "litdata.cli"
    "litdata.cli.handler"
    "litdata.debugger"
    "litdata.processing"
    "litdata.streaming"
    "litdata.utilities"
  ];

  doCheck = false; # uses lightning_sdk; only available on PyPI

  meta = {
    description = "Speed up model training by fixing data loading";
    homepage = "https://github.com/Lightning-AI/litdata";
    changelog = "https://github.com/Lightning-AI/litData/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "litdata";
  };
})
