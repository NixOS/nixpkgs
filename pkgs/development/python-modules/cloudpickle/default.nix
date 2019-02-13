{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f169a8523a40eb0a3452e1878aac31da6759409fbafa51dd50d89d4a6b42bcf1";
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
