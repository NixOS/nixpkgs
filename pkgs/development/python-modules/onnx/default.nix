{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  pybind11,
  setuptools,

  # buildInputs
  abseil-cpp,
  protobuf,
  gtest,

  # dependencies
  numpy,
  typing-extensions,

  # tests
  google-re2,
  ml-dtypes,
  nbval,
  parameterized,
  pillow,
  pytestCheckHook,
  tabulate,
  writableTmpDirAsHomeHook,
}:

let
  gtestStatic = gtest.override { static = true; };
in
buildPythonPackage rec {
  pname = "onnx";
  version = "1.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    tag = "v${version}";
    hash = "sha256-UhtF+CWuyv5/Pq/5agLL4Y95YNP63W2BraprhRqJOag=";
  };

  build-system = [
    cmake
    protobuf
    setuptools
  ];

  buildInputs = [
    abseil-cpp
    gtestStatic
    pybind11
  ];

  dependencies = [
    protobuf
    numpy
    typing-extensions
  ];

  nativeCheckInputs = [
    google-re2
    ml-dtypes
    nbval
    parameterized
    pillow
    pytestCheckHook
    tabulate
    writableTmpDirAsHomeHook
  ];

  postPatch = ''
    rm -r third_party

    chmod +x tools/protoc-gen-mypy.sh.in
    patchShebangs tools/protoc-gen-mypy.sh.in
  '';

  preConfigure = ''
    # Set CMAKE_INSTALL_LIBDIR to lib explicitly, because otherwise it gets set
    # to lib64 and cmake incorrectly looks for the protobuf library in lib64
    export CMAKE_ARGS="-DCMAKE_INSTALL_LIBDIR=lib -DONNX_USE_PROTOBUF_SHARED_LIBS=ON"
    export CMAKE_ARGS+=" -Dgoogletest_STATIC_LIBRARIES=${gtestStatic}/lib/libgtest.a"
    export ONNX_BUILD_TESTS=1
  '';

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  # The executables are just utility scripts that aren't too important
  postInstall = ''
    rm -r $out/bin
  '';

  # The setup.py does all the configuration
  dontUseCmakeConfigure = true;

  # detecting source dir as a python package confuses pytest
  preCheck = ''
    rm onnx/__init__.py
  '';

  pytestFlagsArray = [
    "onnx/test"
    "examples"
  ];

  __darwinAllowLocalNetworking = true;

  postCheck = ''
    # run "cpp" tests
    .setuptools-cmake-build/onnx_gtests
  '';

  pythonImportsCheck = [ "onnx" ];

  meta = {
    description = "Open Neural Network Exchange";
    homepage = "https://onnx.ai";
    changelog = "https://github.com/onnx/onnx/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ acairncross ];
  };
}
