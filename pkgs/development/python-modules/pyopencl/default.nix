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

buildPythonPackage (finalAttrs: {
  pname = "pyopencl";
  version = "2026.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pyopencl";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-n1xdJbq+RPW2p8MNc6YA9+GlYokSbW8llbCFFv1wCcE=";
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
    changelog = "https://github.com/inducer/pyopencl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
