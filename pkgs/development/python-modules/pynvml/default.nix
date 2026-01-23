{
  lib,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  nvidia-ml-py,
  pynvml,
}:

buildPythonPackage rec {
  pname = "pynvml";
  version = "13.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gpuopenanalytics";
    repo = "pynvml";
    tag = version;
    hash = "sha256-Jwj3cm0l7qR/q5jzwKbD52L7ePYCdzXrYFOceMA776M=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "nvidia-ml-py"
  ];

  dependencies = [ nvidia-ml-py ];

  pythonImportsCheck = [
    "pynvml_utils"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false;

  passthru.tests.tester-nvmlInit = cudaPackages.writeGpuTestPython { libraries = [ pynvml ]; } ''
    from pynvml_utils import nvidia_smi  # noqa: F401
    nvsmi = nvidia_smi.getInstance()
    print(nvsmi.DeviceQuery('memory.free, memory.total'))
  '';

  meta = {
    description = "Unofficial Python bindings for the NVIDIA Management Library";
    homepage = "https://github.com/gpuopenanalytics/pynvml";
    changelog = "https://github.com/gpuopenanalytics/pynvml?tab=readme-ov-file#release-notes";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
