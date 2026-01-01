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
  version = "0.2.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PA9fUwbX1gFvzJUZaydMrm8H4slZbu0xTk52QVVPuwg=";
  };

  propagatedBuildInputs = [ torch ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "julius" ];

<<<<<<< HEAD
  meta = {
    description = "Nice DSP sweets: resampling, FFT Convolutions. All with PyTorch, differentiable and with CUDA support";
    homepage = "https://pypi.org/project/julius/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
=======
  meta = with lib; {
    description = "Nice DSP sweets: resampling, FFT Convolutions. All with PyTorch, differentiable and with CUDA support";
    homepage = "https://pypi.org/project/julius/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
