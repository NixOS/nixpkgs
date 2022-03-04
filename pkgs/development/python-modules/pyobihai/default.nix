{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pyobihai";
  version = "1.3.2";
  disabled = pythonOlder "3.6";

  # GitHub release, https://github.com/dshokouhi/pyobihai/issues/10
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zhsnJyhXlugK0nJ7FJZZcrq2VDQt1a9uCgsJAIABZ28=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyobihai" ];

  meta = with lib; {
    description = "Python package to interact with Obihai devices";
    homepage = "https://github.com/dshokouhi/pyobihai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
