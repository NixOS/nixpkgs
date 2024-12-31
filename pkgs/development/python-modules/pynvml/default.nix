{
  lib,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  substituteAll,
  pythonOlder,
  addDriverRunpath,
  setuptools,
  pytestCheckHook,
  versioneer,
  pynvml,
}:

buildPythonPackage rec {
  pname = "pynvml";
  version = "11.5.0";
  pyproject = true;
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "gpuopenanalytics";
    repo = "pynvml";
    rev = "refs/tags/${version}";
    hash = "sha256-K3ZENjgi+TVDxr55dRK1y8SwzfgVIzcnD4oEI+KHRa4=";
  };

  patches = [
    (substituteAll {
      src = ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch;
      inherit (addDriverRunpath) driverLink;
    })
  ];

  # unvendor versioneer
  postPatch = ''
    rm versioneer.py
  '';

  nativeBuildInputs = [
    setuptools
    versioneer
  ];

  pythonImportsCheck = [
    "pynvml"
    "pynvml.smi"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # OSError: /run/opengl-driver/lib/libnvidia-ml.so.1: cannot open shared object file: No such file or directory
  doCheck = false;

  passthru.tests.tester-nvmlInit = cudaPackages.writeGpuTestPython { libraries = [ pynvml ]; } ''
    import pynvml
    from pynvml.smi import nvidia_smi  # noqa: F401

    print(f"{pynvml.nvmlInit()=}")
  '';

  meta = with lib; {
    description = "Python bindings for the NVIDIA Management Library";
    homepage = "https://github.com/gpuopenanalytics/pynvml";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
