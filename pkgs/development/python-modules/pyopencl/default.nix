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
  version = "2026.1.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pyopencl";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-jYonctlEmvfZoY8n5eNfh5XQdUPrZRGcKzFVUP78eUk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "nanobind >=3.0" \
        "nanobind"
  '';

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
    CL_INC_DIR = "${lib.getInclude opencl-headers}/include";
    CL_LIB_DIR = "${lib.getLib ocl-icd}/lib";
    CL_LIBNAME = "${lib.getLib ocl-icd}/lib/libOpenCL${stdenv.hostPlatform.extensions.sharedLibrary}";
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
