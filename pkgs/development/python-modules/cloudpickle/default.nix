{ lib, buildPythonPackage, fetchPypi, isPy27, pytest, mock }:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "2.0.0";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cd02f3b417a783ba84a4ec3e290ff7929009fe51f6405423cfccfadd43ba4a4";
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
