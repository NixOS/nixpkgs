{ lib
, stdenv
, buildPythonPackage
, cmake
, fetchFromGitHub
, gtest
, nbval
, numpy
, parameterized
, protobuf
, pybind11
, pytestCheckHook
, pythonOlder
, tabulate
, typing-extensions
, abseil-cpp
}:

let
  gtestStatic = gtest.override { static = true; };
in buildPythonPackage rec {
  pname = "onnx";
  version = "1.14.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ZVSdk6LeAiZpQrrzLxphMbc1b3rNUMpcxcXPP8s/5tE=";
  };

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  buildInputs = [
    abseil-cpp
  ];

  propagatedBuildInputs = [
    protobuf
    numpy
    typing-extensions
  ];

  nativeCheckInputs = [
    nbval
    parameterized
    pytestCheckHook
    tabulate
  ];

  postPatch = ''
    chmod +x tools/protoc-gen-mypy.sh.in
    patchShebangs tools/protoc-gen-mypy.sh.in

    substituteInPlace setup.py \
      --replace 'setup_requires.append("pytest-runner")' ""

    # prevent from fetching & building own gtest
    substituteInPlace CMakeLists.txt \
      --replace 'include(googletest)' ""
    substituteInPlace cmake/unittest.cmake \
      --replace 'googletest)' ')'
  '' + lib.optionalString stdenv.isLinux ''
      # remove this override in 1.15 that will enable to set the CMAKE_CXX_STANDARD with cmakeFlags
      substituteInPlace CMakeLists.txt \
        --replace 'CMAKE_CXX_STANDARD 11' 'CMAKE_CXX_STANDARD 17'
  '' + lib.optionalString stdenv.isDarwin ''
      # remove this override in 1.15 that will enable to set the CMAKE_CXX_STANDARD with cmakeFlags
      substituteInPlace CMakeLists.txt \
        --replace 'CMAKE_CXX_STANDARD 11' 'CMAKE_CXX_STANDARD 14'
  '';

  preConfigure = ''
    # Set CMAKE_INSTALL_LIBDIR to lib explicitly, because otherwise it gets set
    # to lib64 and cmake incorrectly looks for the protobuf library in lib64
    export CMAKE_ARGS="-DCMAKE_INSTALL_LIBDIR=lib -DONNX_USE_PROTOBUF_SHARED_LIBS=ON"
    export CMAKE_ARGS+=" -Dgoogletest_STATIC_LIBRARIES=${gtestStatic}/lib/libgtest.a -Dgoogletest_INCLUDE_DIRS=${lib.getDev gtestStatic}/include"
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
    "onnx/examples"
  ];

  disabledTests = [
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
  ] ++ lib.optionals stdenv.isAarch64 [
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

  disabledTestPaths = [
    # Unexpected output fields from running code: {'stderr'}
    "onnx/examples/np_array_tensorproto.ipynb"
  ];

  __darwinAllowLocalNetworking = true;

  postCheck = ''
    # run "cpp" tests
    .setuptools-cmake-build/onnx_gtests
  '';

  pythonImportsCheck = [
    "onnx"
  ];

  meta = with lib; {
    description = "Open Neural Network Exchange";
    homepage = "https://onnx.ai";
    license = licenses.asl20;
    maintainers = with maintainers; [ acairncross ];
  };
}
