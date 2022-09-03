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
}:

buildPythonPackage rec {
  pname = "onnx";
  version = "1.12.0";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E7PnfSdSO52/TzDfyclZRVhZ1eNOkhxE9xLWm4Np7/k=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    protobuf
    numpy
    six
    typing-extensions
  ];

  checkInputs = [
    nbval
    pytestCheckHook
    tabulate
  ];

  postPatch = ''
    chmod +x tools/protoc-gen-mypy.sh.in
    patchShebangs tools/protoc-gen-mypy.py
    substituteInPlace tools/protoc-gen-mypy.sh.in \
      --replace "/bin/bash" "${bash}/bin/bash"

    sed -i '/pytest-runner/d' setup.py
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
