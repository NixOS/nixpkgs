{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ea6fd33b7521855a97819b3d645f92d51c8763d3ab5df35197cd8e96c19ba6f";
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
