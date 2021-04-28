{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy27
, cmake
, protobuf
, numpy
, six
, typing-extensions
, pytestCheckHook
, nbval
, tabulate
}:

buildPythonPackage rec {
  pname = "onnx";
  version = "1.9.0";

  # Python 2 is not supported as of Onnx v1.8
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yjv2axz2vc2ysniwislsp53fsb8f61y1warrr2ppn2d9ijml1d9";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    protobuf
    numpy
    six
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    nbval
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

  meta = {
    homepage    = "http://onnx.ai";
    description = "Open Neural Network Exchange";
    license     = lib.licenses.mit;
    maintainers = [ lib.maintainers.acairncross ];
  };
}
