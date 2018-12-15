{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0390ecb3731ac035d74c34651460f4a683e9ef7443861712b8d56c20c2f92113";
  };

  buildInputs = [ pytest mock ];

  # See README for tests invocation
  checkPhase = ''
    PYTHONPATH=$PYTHONPATH:'.:tests' py.test
  '';

  # TypeError: cannot serialize '_io.FileIO' object
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Extended pickling support for Python objects";
    homepage = https://github.com/cloudpipe/cloudpickle;
    license = with licenses; [ bsd3 ];
  };
}
