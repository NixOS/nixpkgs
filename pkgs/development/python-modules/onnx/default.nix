{ lib
, fetchpatch
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy27
, cmake
, protobuf
, numpy
, six
, typing-extensions
, typing
, pytestrunner
, pytest
, nbval
, tabulate
}:

buildPythonPackage rec {
  pname = "onnx";
  version = "1.6.0";

  # Due to Protobuf packaging issues this build of Onnx with Python 2 gives
  # errors on import
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ig33jl3591041lyylxp52yi20rfrcqx3i030hd6al8iabzc721v";
  };

  # Remove the unqualified requirement for the typing package for running the
  # tests. typing is already required for the installation, where it is
  # correctly qualified so as to only be required for sufficiently old Python
  # versions.
  # This patch should be in the next release (>1.6).
  patches = [
    (fetchpatch {
      url = "https://github.com/onnx/onnx/commit/c963586d0f8dd5740777b2fd06f04ec60816de9f.patch";
      sha256 = "1hl26cw5zckc91gmh0bdah87jyprccxiw0f4i5h1gwkq28hm6wbj";
    })
  ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    protobuf
    numpy
    six
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.5") [ typing ];

  checkInputs = [
    pytestrunner
    pytest
    nbval
    tabulate
  ];

  postPatch = ''
    patchShebangs tools/protoc-gen-mypy.py
  '';

  # The executables are just utility scripts that aren't too important
  postInstall = ''
    rm -r $out/bin
  '';

  # The setup.py does all the configuration (running CMake)
  dontConfigure = true;

  meta = {
    homepage    = http://onnx.ai;
    description = "Open Neural Network Exchange";
    license     = lib.licenses.mit;
    maintainers = [ lib.maintainers.acairncross ];
  };
}
