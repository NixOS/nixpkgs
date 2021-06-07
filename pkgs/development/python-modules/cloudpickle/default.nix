{ lib, buildPythonPackage, fetchPypi, isPy27, pytest, mock }:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "1.6.0";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "9bc994f9e9447593bd0a45371f0e7ac7333710fcf64a4eb9834bf149f4ef2f32";
  };

  buildInputs = [ pytest mock ];

  # See README for tests invocation
  checkPhase = ''
    PYTHONPATH=$PYTHONPATH:'.:tests' py.test
  '';

  # TypeError: cannot serialize '_io.FileIO' object
  doCheck = false;

  meta = with lib; {
    description = "Extended pickling support for Python objects";
    homepage = "https://github.com/cloudpipe/cloudpickle";
    license = with licenses; [ bsd3 ];
  };
}
