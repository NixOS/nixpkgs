{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  cmake,
  nanobind,
  ninja,
  numpy,
  scikit-build-core,

  # buildInputs
  opencl-headers,
  pybind11,
  ocl-icd,

  # dependencies
  platformdirs,
  pytools,
  typing-extensions,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  mako,
  pocl,
}:

buildPythonPackage rec {
  pname = "pyopencl";
  version = "2025.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pyopencl";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ofAyBaD/iMm2+2PFGVTEzg/kaPmcwlvLPAihRE+JlJg=";
  };

  build-system = [
    cmake
    nanobind
    ninja
    numpy
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    opencl-headers
    ocl-icd
    pybind11
  ];

  dependencies = [
    numpy
    platformdirs
    pytools
    typing-extensions
  ];

  nativeCheckInputs = [
    pocl
    mako
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  env = {
    CL_INC_DIR = "${opencl-headers}/include";
    CL_LIB_DIR = "${ocl-icd}/lib";
    CL_LIBNAME = "${ocl-icd}/lib/libOpenCL${stdenv.hostPlatform.extensions.sharedLibrary}";
  };

  preCheck = ''
    rm -rf pyopencl
  '';

  pythonImportsCheck = [
    "pyopencl"
    "pyopencl.array"
    "pyopencl.cltypes"
    "pyopencl.compyte"
    "pyopencl.elementwise"
    "pyopencl.tools"
  ];

  meta = {
    description = "Python wrapper for OpenCL";
    homepage = "https://github.com/pyopencl/pyopencl";
    changelog = "https://github.com/inducer/pyopencl/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
