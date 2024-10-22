{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  einops,
  numpy,
  timm,
  torch,
}:

buildPythonPackage rec {
  pname = "dynamic-network-architectures";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "dynamic-network-architectures";
    tag = "v${version}";
    hash = "sha256-n458ZRaQqp9Wa4PbT/aoGrsPXOKdNmeah97YDtwXj6c=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    einops
    numpy
    timm
    torch
  ];

  doCheck = false; # no tests (as of v0.3.1)

  pythonImportsCheck = [ "dynamic_network_architectures" ];

  meta = {
    description = "Neural network architectures in Pytorch for varying image dimensions and channels";
    homepage = "https://github.com/MIC-DKFZ/dynamic-network-architectures";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
