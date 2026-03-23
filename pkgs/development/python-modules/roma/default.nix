{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  numpy,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "roma";
  version = "1.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "naver";
    repo = "roma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ssfgEz2z9IxZpjaQTySXXZ1BSRpnlCcQG2pm/Q3G514=";
  };

  build-system = [
    setuptools
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
