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
  appdirs,
  cffi,
  darwin,
  decorator,
  mako,
  numpy,
  ocl-icd,
  oldest-supported-numpy,
  opencl-headers,
  platformdirs,
  pybind11,
  pytestCheckHook,
  pytools,
  six,
}:

let
  os-specific-buildInputs =
    if stdenv.isDarwin then [ darwin.apple_sdk.frameworks.OpenCL ] else [ ocl-icd ];
in
buildPythonPackage rec {
  pname = "pyopencl";
  version = "2024.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pyopencl";
    rev = "refs/tags/v${version}";
    hash = "sha256-DfZCtTeN1a1KS2qUU6iztba4opAVC/RUCe/hnkqTbII=";
  };

  build-system = [
    cmake
    nanobind
    ninja
    numpy
    oldest-supported-numpy
    pathspec
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    opencl-headers
    pybind11
  ] ++ os-specific-buildInputs;

  dependencies = [
    appdirs
    cffi
    decorator
    mako
    numpy
    platformdirs
    pytools
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    export HOME=$(mktemp -d)
    rm -rf pyopencl
  '';

  # gcc: error: pygpu_language_opencl.cpp: No such file or directory
  doCheck = false;

  pythonImportsCheck = [ "pyopencl" ];

  meta = {
    description = "Python wrapper for OpenCL";
    homepage = "https://github.com/pyopencl/pyopencl";
    changelog = "https://github.com/inducer/pyopencl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
