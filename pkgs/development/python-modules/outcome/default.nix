{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, pytest
}:

buildPythonPackage rec {
  pname = "outcome";
  version = "1.0.1";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc7822068ba7dd0fc2532743611e8a73246708d3564e29a39f93d6ab3701b66f";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ attrs ];
  # Has a test dependency on trio, which depends on outcome.
  doCheck = false;

  meta = {
    description = "Capture the outcome of Python function calls.";
    homepage = https://github.com/python-trio/outcome;
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
