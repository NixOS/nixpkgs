{
  lib,
  stdenv,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  gtest,
  nbval,
  numpy,
  parameterized,
  protobuf_21,
  pybind11,
  pytestCheckHook,
  pythonOlder,
  tabulate,
  typing-extensions,
  abseil-cpp,
  google-re2,
  pillow,
  protobuf,
  setuptools,
}:

let
  gtestStatic = gtest.override { static = true; };
in
buildPythonPackage rec {
  pname = "onnx";
  version = "1.17.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

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
    protobuf_21 # for protoc
  ];

  buildInputs = [
    abseil-cpp
    protobuf_21
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

  preCheck = ''
    export HOME=$(mktemp -d)

    # detecting source dir as a python package confuses pytest
    mv onnx/__init__.py onnx/__init__.py.hidden
  '';

  pytestFlagsArray = [
    "onnx/test"
    "examples"
  ];

  disabledTests =
    [
      # attempts to fetch data from web
      "test_bvlc_alexnet_cpu"
      "test_densenet121_cpu"
      "test_inception_v1_cpu"
      "test_inception_v2_cpu"
      "test_resnet50_cpu"
      "test_shufflenet_cpu"
      "test_squeezenet_cpu"
      "test_vgg19_cpu"
      "test_zfnet512_cpu"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # AssertionError: Output 0 of test 0 in folder
      "test__pytorch_converted_Conv2d_depthwise_padded"
      "test__pytorch_converted_Conv2d_dilated"
      "test_dft"
      "test_dft_axis"
      # AssertionError: Mismatch in test 'test_Conv2d_depthwise_padded'
      "test_xor_bcast4v4d"
      # AssertionError: assert 1 == 0
      "test_ops_tested"
    ];

  __darwinAllowLocalNetworking = true;

  postCheck = ''
    # run "cpp" tests
    .setuptools-cmake-build/onnx_gtests
  '';

  pythonImportsCheck = [ "onnx" ];

  meta = with lib; {
    changelog = "https://github.com/onnx/onnx/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    description = "Open Neural Network Exchange";
    homepage = "https://onnx.ai";
    license = licenses.asl20;
    maintainers = with maintainers; [ acairncross ];
  };
}
