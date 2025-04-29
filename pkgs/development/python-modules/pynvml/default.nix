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
  version = "12.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gpuopenanalytics";
    repo = "pynvml";
    tag = version;
    hash = "sha256-bfES6QqL9DO7rmQ3btXxVzW0KlL0eHyUvYJVeijymBk=";
  };

  build-system = [
    setuptools
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
