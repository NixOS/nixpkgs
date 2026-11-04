{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  numpy,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "roma";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "naver";
    repo = "roma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y8pctpPCNy+Bl8dn9h37uRFL+Iz8yRk1D7wedmDErPc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "roma"
  ];

  meta = {
    changelog = "https://naver.github.io/roma/#changelog";
    description = "Lightweight library to deal with 3D rotations in PyTorch";
    homepage = "https://github.com/naver/roma";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
