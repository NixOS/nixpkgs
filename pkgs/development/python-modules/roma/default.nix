{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  numpy,
  torch,
}:

buildPythonPackage rec {
  pname = "roma";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "naver";
    repo = "roma";
    tag = "v${version}";
    hash = "sha256-DuQjnHoZKQF/xnFMYb0OXhycsRcK4oHoocq6o+NoGRs=";
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

  meta = with lib; {
    description = "Lightweight library to deal with 3D rotations in PyTorch";
    homepage = "https://github.com/naver/roma";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nim65s ];
  };
}
