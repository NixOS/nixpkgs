{
<<<<<<< HEAD
  buildPythonPackage,
  onnx, # pkgs.onnx
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # dependencies
  ml-dtypes,
  numpy,
<<<<<<< HEAD
  protobuf,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  typing-extensions,

  # tests
  parameterized,
  pillow,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:
<<<<<<< HEAD
buildPythonPackage {
  inherit (onnx)
    pname
    src # Needed for testing.
    version
    ;

  format = "wheel";

  dontUseWheelUnpack = true;

  postUnpack = ''
    cp -rv "${onnx.dist}" "$sourceRoot/dist"
    chmod +w "$sourceRoot/dist"
  '';

  buildInputs = [
    # onnx must be included to avoid shrinking during fixupPhase removing the RUNPATH entry on
    # onnx_cpp2py_export.cpython-*.so.
    onnx
=======

let
  gtestStatic = gtest.override { static = true; };
in
buildPythonPackage rec {
  pname = "onnx";
  version = "1.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    tag = "v${version}";
    hash = "sha256-dDc7ugzQHcArf9TRcF9Ofv16jc3gqhMWCZrYKJ7Udfw=";
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  dependencies = [
    ml-dtypes
    numpy
    protobuf
    typing-extensions
  ];

  nativeCheckInputs = [
    parameterized
    pillow
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

<<<<<<< HEAD
  # The executables are just utility scripts that aren't too important
  postInstall = ''
    rm -rv $out/bin
  '';

=======
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

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # detecting source dir as a python package confuses pytest
  preCheck = ''
    rm onnx/__init__.py
  '';

  enabledTestPaths = [
    "onnx/test"
    "examples"
  ];

  __darwinAllowLocalNetworking = true;

<<<<<<< HEAD
  pythonImportsCheck = [ "onnx" ];

  meta = {
    # Explicitly inherit from ONNX's meta to avoid pulling in attributes added by stdenv.mkDerivation.
    inherit (onnx.meta)
      changelog
      description
      homepage
      license
      maintainers
      ;
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
