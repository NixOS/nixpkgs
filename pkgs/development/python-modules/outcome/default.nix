{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, pytest
}:

buildPythonPackage rec {
  pname = "outcome";
  version = "0.1.0a0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cqwakzigw0602dxlb7c1882jwr8hn5nrxk1l8iwlmzc9whh48wn";
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
