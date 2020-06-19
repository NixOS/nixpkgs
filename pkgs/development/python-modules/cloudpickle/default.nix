{ stdenv, buildPythonPackage, fetchPypi, isPy27, pytest, mock }:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "1.4.1";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b6258a20a143603d53b037a20983016d4e978f554ec4f36b3d0895b947099ae";
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
    homepage = "https://github.com/cloudpipe/cloudpickle";
    license = with licenses; [ bsd3 ];
  };
}
