{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  scipy,
  setuptools,
  soundfile,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyloudnorm";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csteinmetz1";
    repo = "pyloudnorm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-47CU/veoOQYv5G1QBm3F+j7ltmVvcWSY4hQWtaC6WEI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    soundfile
  ];

  pythonImportsCheck = [ "pyloudnorm" ];

  meta = {
    description = "Implementation of ITU-R BS.1770-4 loudness algorithm in Python";
    homepage = "https://github.com/csteinmetz1/pyloudnorm";
    changelog = "https://github.com/csteinmetz1/pyloudnorm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
