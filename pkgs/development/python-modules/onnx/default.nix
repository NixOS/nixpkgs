{ lib
, buildPythonPackage
, python3
, bash
, cmake
, fetchFromGitHub
, gtest
, isPy27
, nbval
, numpy
, protobuf
, pybind11
, pytestCheckHook
, six
, tabulate
, typing-extensions
, pythonRelaxDepsHook
}:

let
  gtestStatic = gtest.override { static = true; };
in buildPythonPackage rec {
  pname = "onnx";
  version = "1.13.0";
  format = "setuptools";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-D8POBAkZVr0O5i4qsSuYRkDfL8WsDTqzgNACmmkFwGs=";
  };

  nativeBuildInputs = [
    cmake
    pythonRelaxDepsHook
    pybind11
  ];

  pythonRelaxDeps = [ "protobuf" ];

  propagatedBuildInputs = [
    protobuf
    numpy
    six
    typing-extensions
  ];

  nativeCheckInputs = [
    nbval
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
  '' + lib.optionalString doCheck ''
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

  doCheck = true;
  preCheck = ''
    export HOME=$(mktemp -d)

    # detecting source dir as a python package confuses pytest
    mv onnx/__init__.py onnx/__init__.py.hidden
  '';
  pytestFlagsArray = [ "onnx/test" "onnx/examples" ];
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
  ];
  disabledTestPaths = [
    # Unexpected output fields from running code: {'stderr'}
    "onnx/examples/np_array_tensorproto.ipynb"
  ];
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
