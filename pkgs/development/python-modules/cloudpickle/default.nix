{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0e63dd89ed5285171a570186751bc9b84493675e99e12789e9a5dc5490ef554";
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
