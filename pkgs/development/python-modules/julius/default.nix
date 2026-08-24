{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  torch,
}:

buildPythonPackage rec {
  pname = "julius";
  version = "0.2.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1pHmUSAJMK/+pPbIScJulf7IRghyga49GndX6skCU9U=";
  };

  propagatedBuildInputs = [ torch ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "julius" ];

  meta = {
    description = "Nice DSP sweets: resampling, FFT Convolutions. All with PyTorch, differentiable and with CUDA support";
    homepage = "https://pypi.org/project/julius/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
}
