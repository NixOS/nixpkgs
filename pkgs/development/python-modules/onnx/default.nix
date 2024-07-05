{
  lib,
  stdenv,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  fetchpatch,
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
}:

let
  gtestStatic = gtest.override { static = true; };
in
buildPythonPackage rec {
  pname = "onnx";
  version = "1.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Jzga1IiUO5LN5imSUmnbsjYtapRatTihx38EOUjm9Os=";
  };

  patches = [
    ./1.15.0-CVE-2024-27318.patch
    (fetchpatch {
      name = "CVE-2024-27319.patch";
      url = "https://github.com/onnx/onnx/commit/08a399ba75a805b7813ab8936b91d0e274b08287.patch";
      hash = "sha256-9X92N9i/hpQjDGe4I/C+FwUcTUTtP2Nf7+pcTA2sXoA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  buildInputs = [
    abseil-cpp
    protobuf
    google-re2
    pillow
  ];

  propagatedBuildInputs = [
    protobuf_21
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
    ++ lib.optionals stdenv.isAarch64 [
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

  pythonImportsCheck = [ "onnx" ];

  meta = with lib; {
    description = "Open Neural Network Exchange";
    homepage = "https://onnx.ai";
    license = licenses.asl20;
    maintainers = with maintainers; [ acairncross ];
  };
}
