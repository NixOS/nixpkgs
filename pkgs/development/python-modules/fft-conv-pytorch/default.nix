{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  torch,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fft-conv-pytorch";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fkodom";
    repo = "fft-conv-pytorch";
    tag = version;
    hash = "sha256-SPoGmJ3cooztDsJl9jTzcSREhAHA8W4AIeHWbj9w8oM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    torch
  ];

  env.FFT_CONV_PYTORCH_VERSION = version;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fft_conv_pytorch"
  ];

  meta = {
    description = "Implementation of 1D, 2D, and 3D FFT convolutions in PyTorch";
    homepage = "https://github.com/fkodom/fft-conv-pytorch";
    changelog = "https://github.com/fkodom/fft-conv-pytorch/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
