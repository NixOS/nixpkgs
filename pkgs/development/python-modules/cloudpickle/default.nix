{ stdenv, buildPythonPackage, fetchPypi, isPy27, pytest, mock }:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "1.5.0";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "820c9245cebdec7257211cbe88745101d5d6a042bca11336d78ebd4897ddbc82";
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
