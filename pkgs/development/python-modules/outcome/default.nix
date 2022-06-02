{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, pytest
}:

buildPythonPackage rec {
  pname = "outcome";
  version = "1.1.0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e862f01d4e626e63e8f92c38d1f8d5546d3f9cce989263c521b2e7990d186967";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ attrs ];
  # Has a test dependency on trio, which depends on outcome.
  doCheck = false;

  meta = {
    description = "Capture the outcome of Python function calls.";
    homepage = "https://github.com/python-trio/outcome";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
