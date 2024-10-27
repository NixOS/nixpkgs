{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  pybind11,
  setuptools,

  # nativeBuildInputs
  protobuf-core,

  # buildInputs
  abseil-cpp,
  protobuf,
  gtest,

  # dependencies
  numpy,

  google-re2,
  nbval,
  parameterized,
  pillow,
  pytestCheckHook,
  tabulate,
}:

let
  gtestStatic = gtest.override { static = true; };
in
buildPythonPackage rec {
  pname = "onnx";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    rev = "refs/tags/v${version}";
    hash = "sha256-9oORW0YlQ6SphqfbjcYb0dTlHc+1gzy9quH/Lj6By8Q=";
  };

  build-system = [
    cmake
    protobuf
    setuptools
  ];

  nativeBuildInputs = [
    protobuf-core # `protoc` required
  ];

  buildInputs = [
    abseil-cpp
    gtestStatic
    pybind11
  ];

  dependencies = [
    protobuf
    numpy
  ];

  nativeCheckInputs = [
    google-re2
    nbval
    parameterized
    pillow
    pytestCheckHook
    tabulate
  ];

  postPatch = ''
    rm -r third_party

    chmod +x tools/protoc-gen-mypy.sh.in
    patchShebangs tools/protoc-gen-mypy.sh.in
  '';

  env = {
    ONNX_BUILD_TESTS = true;
  };
  cmakeFlags = [
    # Set CMAKE_INSTALL_LIBDIR to lib explicitly, because otherwise it gets set
    # to lib64 and cmake incorrectly looks for the protobuf library in lib64
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")

    # Otherwise ONNX tries to download abseil-cpp
    (lib.cmakeBool "ONNX_USE_PROTOBUF_SHARED_LIBS" true)

    (lib.cmakeFeature "googletest_STATIC_LIBRARIES" "${lib.getStatic gtestStatic}/lib/libgtest.a")
  ];

  preConfigure = ''
    concatTo CMAKE_ARGS cmakeFlags
  '';

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  preInstall = ''
    (cd .setuptools-cmake-build && make install)
  '';
  # The executables are just utility scripts that aren't too important
  postInstall = ''
    rm -r $out/bin
  '';

  # The setup.py does all the configuration wrong
  # dontUseCmakeConfigure = true;

  cmakeBuildDir = ".setuptools-cmake-build";
  postConfigure = "cd ..";

  preCheck = ''
    export HOME=$(mktemp -d)

    # detecting source dir as a python package confuses pytest
    mv onnx/__init__.py onnx/__init__.py.hidden
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
    changelog = "https://github.com/onnx/onnx/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ acairncross ];
  };
}
