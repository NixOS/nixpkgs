{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  cmake,
  scikit-build-core,
  pathspec,
  ninja,
  nanobind,

  # dependencies
  darwin,
  numpy,
  ocl-icd,
  opencl-headers,
  platformdirs,
  pybind11,
  pytools,

  # tests
  pytestCheckHook,
}:

let
  os-specific-buildInputs = if stdenv.isDarwin then [ darwin.apple_sdk.frameworks.OpenCL ] else [ ocl-icd ];
in
buildPythonPackage rec {
  pname = "pyopencl";
  version = "2024.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pyopencl";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-VeaEDYnGfMYf9/WqMIZ9g4KounD48eWF3Romt79RMEQ=";
  };

  build-system = [
    cmake
    nanobind
    ninja
    numpy
    pathspec
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    opencl-headers
    pybind11
  ] ++ os-specific-buildInputs;

  dependencies = [
    numpy
    platformdirs
    pytools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)

    # import from $out
    rm -r pyopencl
  '';

  # pyopencl._cl.LogicError: clGetPlatformIDs failed: PLATFORM_NOT_FOUND_KHR
  doCheck = false;

  pythonImportsCheck = [
    "pyopencl"
    "pyopencl.array"
    "pyopencl.cltypes"
    "pyopencl.elementwise"
    "pyopencl.tools"
  ];

  meta = with lib; {
    changelog = "https://github.com/inducer/pyopencl/releases/tag/v${version}";
    description = "Python wrapper for OpenCL";
    homepage = "https://github.com/inducer/pyopencl";
    license = licenses.mit;
  };
}
