{ lib
, buildPythonPackage
, fetchPypi
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "expiring-dict";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PEBK2x5DaUaMt+Ub+8nEcNfi6GPv4qHHXU7XBtDc4aY=";
  };

  propagatedBuildInputs = [
    sortedcontainers
  ];

  pythonImportsCheck = [
    "expiring_dict"
  ];

  meta = with lib; {
    description = "Python dict with TTL support for auto-expiring caches";
    homepage = "https://github.com/dparker2/py-expiring-dict";
    license = licenses.mit;
    maintainers = with maintainers; [ ajs124 ];
  };
}
