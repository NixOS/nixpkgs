{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  ninja,
  pkg-config,
  python3,
  protobuf,
  # Sources required to build
  cpuinfo,
  fp16,
  fxdiv,
  psimd,
  pthreadpool,
  python3Packages,
  # Sources required to test
  gtest,
  # Configuration options
  buildSharedLibs ? true,
}: let
  gtestStatic = gtest.override {static = true;};
  # protobuf-17 = protobuf.override {};
  setBuildSharedLibrary = bool:
    if bool
    then "shared"
    else "static";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "onnx";
    # TODO(@connorbaker): Can't use our current version of onnx due to this issue: https://github.com/onnx/onnx/issues/5430; requires us to use a version of onnx that is not yet released because the patchset isn't clean.
    version = "8a980683df9acbcb82dc3385fc7eb8cce4ed840f";

    src = fetchFromGitHub {
      owner = finalAttrs.pname;
      repo = finalAttrs.pname;
      rev = "8a980683df9acbcb82dc3385fc7eb8cce4ed840f";
      hash = "sha256-i60ypUNofpqOtnmrpkNA3j7iDEYQMtDSuSzTw4V/X3s=";
    };

    # patches = [
    #   (fetchpatch {
    #     url = "https://github.com/onnx/onnx/pull/5119.patch";
    #     hash = "sha256-FGLq1sLO7U+pCCPXGGLN+UcH6NjarxoSBl8UDtb5UBs=";
    #   })
    #   (fetchpatch {
    #     url = "https://github.com/onnx/onnx/pull/5196.patch";
    #     hash = "sha256-VDmhB3nNP1mPNNuBszvVTTq3appM7msA+K6WRK1Tf6Y=";
    #   })
    # ];

    doCheck = true;

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
      python3
      protobuf
      # pybind11
    ];

    # Though abseil-cpp is a propagatedBuildInput of protobuf, Nix doesn't see it here.
    # Moving protobuf to buildInputs fixes this, but then we have protobuf in the runtime
    # environment, which we don't want (it is a build-time dependency only).
    buildInputs = [
      protobuf.abseil-cpp
    ];

    # propagatedBuildInputs = [
    #   protobuf
    #   numpy
    #   typing-extensions
    # ];

    # nativeCheckInputs = [
    #   nbval
    #   parameterized
    #   pytestCheckHook
    #   tabulate
    # ];

    # patches = [
    #   (fetchpatch {
    #     url = "https://github.com/onnx/onnx/pull/5196.patch";
    #     hash = "sha256-VDmhB3nNP1mPNNuBszvVTTq3appM7msA+K6WRK1Tf6Y=";
    #   })
    #   (fetchpatch {
    #     url = "https://github.com/onnx/onnx/pull/5355.patch";
    #     hash = "sha256-WFcqodTydsllL4hJvKQ95D2xHNmWw7Jjwgg67a/UbZc=";
    #   })
    # ];

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

    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=${setBuildSharedLibrary buildSharedLibs}"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_CXX_STANDARD=17" # required by abseil-cpp; bump when abseil-cpp does
      "-DONNX_USE_PROTOBUF_SHARED_LIBS=ON"
      "-DONNX_BUILD_TESTS=ON"
      "-Dgoogletest_STATIC_LIBRARIES=${gtestStatic}/lib/libgtest.a"
      "-Dgoogletest_INCLUDE_DIRS=${lib.getDev gtestStatic}/include"
    ];

    # preConfigure = ''
    #   # Set CMAKE_INSTALL_LIBDIR to lib explicitly, because otherwise it gets set
    #   # to lib64 and cmake incorrectly looks for the protobuf library in lib64
    #   export CMAKE_ARGS="-DCMAKE_INSTALL_LIBDIR=lib -DONNX_USE_PROTOBUF_SHARED_LIBS=ON"
    #   export CMAKE_ARGS+=" -Dgoogletest_STATIC_LIBRARIES=${gtestStatic}/lib/libgtest.a -Dgoogletest_INCLUDE_DIRS=${lib.getDev gtestStatic}/include"
    #   export ONNX_BUILD_TESTS=1
    # '';

    # preBuild = ''
    #   export MAX_JOBS=$NIX_BUILD_CORES
    # '';

    # The executables are just utility scripts that aren't too important
    # postInstall = ''
    #   rm -r $out/bin
    # '';

    # The setup.py does all the configuration
    # dontUseCmakeConfigure = true;

    # preCheck = ''
    #   export HOME=$(mktemp -d)

    #   # detecting source dir as a python package confuses pytest
    #   mv onnx/__init__.py onnx/__init__.py.hidden
    # '';

    # pytestFlagsArray = [
    #   "onnx/test"
    #   "onnx/examples"
    # ];

    # disabledTests =
    #   [
    #     # attempts to fetch data from web
    #     "test_bvlc_alexnet_cpu"
    #     "test_densenet121_cpu"
    #     "test_inception_v1_cpu"
    #     "test_inception_v2_cpu"
    #     "test_resnet50_cpu"
    #     "test_shufflenet_cpu"
    #     "test_squeezenet_cpu"
    #     "test_vgg19_cpu"
    #     "test_zfnet512_cpu"
    #   ]
    #   ++ lib.optionals stdenv.isAarch64 [
    #     # AssertionError: Output 0 of test 0 in folder
    #     "test__pytorch_converted_Conv2d_depthwise_padded"
    #     "test__pytorch_converted_Conv2d_dilated"
    #     "test_dft"
    #     "test_dft_axis"
    #     # AssertionError: Mismatch in test 'test_Conv2d_depthwise_padded'
    #     "test_xor_bcast4v4d"
    #     # AssertionError: assert 1 == 0
    #     "test_ops_tested"
    #   ];

    # disabledTestPaths = [
    #   # Unexpected output fields from running code: {'stderr'}
    #   "onnx/examples/np_array_tensorproto.ipynb"
    # ];

    __darwinAllowLocalNetworking = true;

    # postCheck = ''
    #   # run "cpp" tests
    #   .setuptools-cmake-build/onnx_gtests
    # '';

    # pythonImportsCheck = [
    #   "onnx"
    # ];

    meta = with lib; {
      description = "Open Neural Network Exchange";
      homepage = "https://onnx.ai";
      license = licenses.asl20;
      maintainers = with maintainers; [acairncross];
    };
  })
