{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, pytest
}:

buildPythonPackage rec {
  pname = "outcome";
  version = "1.0.0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wdcakx1r1317bx6139k9gv6k272fryid83d1kk0r43andfw0n4x";
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
