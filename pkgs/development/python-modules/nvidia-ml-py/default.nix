{
  lib,
  fetchPypi,
  buildPythonPackage,
  substituteAll,
  addDriverRunpath,
  setuptools,
  cudaPackages,
  nvidia-ml-py,
}:

buildPythonPackage rec {
  pname = "nvidia-ml-py";
  version = "12.560.30";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-8CVNx0AGR2gKBy7gJQm/1GECtgvf7KMhV21NSBfn/pc=";
  };

  patches = [
    (substituteAll {
      src = ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch;
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
        import pynvml
        from pynvml.smi import nvidia_smi  # noqa: F401

        print(f"{pynvml.nvmlInit()=}")
      '';

  meta = {
    description = "Python Bindings for the NVIDIA Management Library";
    homepage = "https://pypi.org/project/nvidia-ml-py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
