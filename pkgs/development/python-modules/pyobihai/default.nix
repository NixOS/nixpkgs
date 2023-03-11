{ lib
, buildPythonPackage
, defusedxml
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pyobihai";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # GitHub release, https://github.com/dshokouhi/pyobihai/issues/10
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P6tKpssey59SdjS/QWpuv1UUagjR7RVAl6rse/O79mg=";
  };

  propagatedBuildInputs = [
    defusedxml
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyobihai"
  ];

  meta = with lib; {
    description = "Python package to interact with Obihai devices";
    homepage = "https://github.com/dshokouhi/pyobihai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
