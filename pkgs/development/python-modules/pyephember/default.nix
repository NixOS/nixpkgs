{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pyephember";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3eMdkP7u3TTg1AUK4OR7AGZkD0FxUUPp/etvZ2Rw74E=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyephember"
  ];

  meta = with lib; {
    description = "Python client to the EPH Control Systems Ember API";
    homepage = "https://github.com/ttroy50/pyephember";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
