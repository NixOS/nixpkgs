{ lib
, buildPythonPackage
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
  version = "1.10.2";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JNc8p9/X5sczmUT4lVS0AQcZiZM3kk/KFEfY8bXbUNY=";
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
    patchShebangs tools/protoc-gen-mypy.sh.in tools/protoc-gen-mypy.py

    substituteInPlace setup.py \
      --replace "setup_requires.append('pytest-runner')" ""
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

  pythonImportsCheck = [
    "onnx"
  ];

  meta = with lib; {
    description = "Open Neural Network Exchange";
    homepage = "http://onnx.ai";
    license = licenses.asl20;
    maintainers = with maintainers; [ acairncross ];
  };
}
