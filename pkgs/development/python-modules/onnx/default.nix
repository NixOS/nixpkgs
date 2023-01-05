{ lib
, buildPythonPackage
, bash
, cmake
, fetchPypi
, isPy27
, nbval
, numpy
, protobuf
, pytestCheckHook
, six
, tabulate
, typing-extensions
, pythonRelaxDepsHook
, pytest-runner
}:

buildPythonPackage rec {
  pname = "onnx";
  version = "1.13.0";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QQs5lQNnhX+XtlCTaB/iSVouI9Y3d6is6vlsVqFtFm4=";
  };

  nativeBuildInputs = [
    cmake
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "protobuf" ];

  propagatedBuildInputs = [
    protobuf
    numpy
    six
    typing-extensions
  ];

  checkInputs = [
    nbval
    pytestCheckHook
    pytest-runner
    tabulate
  ];

  postPatch = ''
    chmod +x tools/protoc-gen-mypy.sh.in
    patchShebangs tools/protoc-gen-mypy.sh.in
  '';

  # Set CMAKE_INSTALL_LIBDIR to lib explicitly, because otherwise it gets set
  # to lib64 and cmake incorrectly looks for the protobuf library in lib64
  preConfigure = ''
    export CMAKE_ARGS="-DCMAKE_INSTALL_LIBDIR=lib -DONNX_USE_PROTOBUF_SHARED_LIBS=ON"
  '';

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  disabledTestPaths = [
    # Unexpected output fields from running code: {'stderr'}
    "onnx/examples/np_array_tensorproto.ipynb"
  ];

  # The executables are just utility scripts that aren't too important
  postInstall = ''
    rm -r $out/bin
  '';

  # The setup.py does all the configuration
  dontUseCmakeConfigure = true;

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
