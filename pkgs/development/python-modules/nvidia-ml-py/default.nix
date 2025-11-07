{
  lib,
  fetchPypi,
  buildPythonPackage,
  replaceVars,
  addDriverRunpath,
  setuptools,
  cudaPackages,
  nvidia-ml-py,
}:

buildPythonPackage rec {
  pname = "nvidia-ml-py";
  version = "13.580.82";

  pyproject = true;

  src = fetchPypi {
    pname = "nvidia_ml_py";
    inherit version;
    hash = "sha256-DAKIBdxToOKmmF6oAYiBl3Zawu+PHJ4pp78NNhal78c=";
  };

  patches = [
    (replaceVars ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch {
      inherit (addDriverRunpath) driverLink;
    })
  ];

  build-system = [
    setuptools
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pynvml" ];

  passthru.tests.tester-nvmlInit =
    cudaPackages.writeGpuTestPython { libraries = [ nvidia-ml-py ]; }
      ''
        from pynvml import (
          nvmlInit,
          nvmlSystemGetDriverVersion,
          nvmlDeviceGetCount,
          nvmlDeviceGetHandleByIndex,
          nvmlDeviceGetName,
        )

        nvmlInit()
        print(f"Driver Version: {nvmlSystemGetDriverVersion()}")

        for i in range(nvmlDeviceGetCount()):
            handle = nvmlDeviceGetHandleByIndex(i)
            print(f"Device {i} : {nvmlDeviceGetName(handle)}")
      '';

  meta = {
    description = "Python Bindings for the NVIDIA Management Library";
    homepage = "https://pypi.org/project/nvidia-ml-py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
