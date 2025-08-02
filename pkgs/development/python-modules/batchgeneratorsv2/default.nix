{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  batchgenerators,
  fft-conv-pytorch,
  numpy,
  torch,
}:

buildPythonPackage rec {
  pname = "batchgeneratorsv2";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "batchgeneratorsv2";
    tag = "v${version}";
    hash = "sha256-UoEYSuDD+6ResA0luCZ3LxKGp9H9Mkcnvok/O673ITk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    batchgenerators
    fft-conv-pytorch
    numpy
    torch
  ];

  pythonImportsCheck = [
    "batchgeneratorsv2"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/MIC-DKFZ/batchgeneratorsv2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
