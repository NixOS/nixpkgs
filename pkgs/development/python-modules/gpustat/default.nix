{
  lib,
  blessed,
  buildPythonPackage,
  fetchPypi,
  mockito,
  nvidia-ml-py,
  psutil,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "gpustat";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wY0+1VGPwWMAxC1pTevHCuuzvlXK6R8dtk1jtfqK+dg=";
  };

  pythonRelaxDeps = [ "nvidia-ml-py" ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    blessed
    nvidia-ml-py
    psutil
  ];

  nativeCheckInputs = [
    mockito
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gpustat" ];

  meta = {
    description = "Simple command-line utility for querying and monitoring GPU status";
    mainProgram = "gpustat";
    homepage = "https://github.com/wookayin/gpustat";
    changelog = "https://github.com/wookayin/gpustat/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ billhuang ];
  };
}
