{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, pytest
}:

buildPythonPackage rec {
  pname = "outcome";
  version = "1.2.0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b4K9PeRdowPPH3ceyvoWM3UKNYQ2qLtg4Goc63RdJnI=";
  };

  nativeCheckInputs = [ pytest ];
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
