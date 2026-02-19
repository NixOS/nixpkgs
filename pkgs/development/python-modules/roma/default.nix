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
  version = "1.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "naver";
    repo = "roma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0R8p8pQxLQqK7MTbk9J5lFtA13XJth76Glemkfj9X/E=";
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
