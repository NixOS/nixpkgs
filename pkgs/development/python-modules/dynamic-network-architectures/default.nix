{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  torch,
}:

buildPythonPackage rec {
  pname = "dynamic-network-architectures";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "dynamic-network-architectures";
    tag = "v${version}";
    hash = "sha256-DH351TJwGfY5K0+C3A55QB3pe4V5iYZq0qWewWN4Ohw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
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
