{ lib
, buildPythonPackage
, fetchPypi
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-localserver";
  version = "0.5.1.post0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ec7f8e6534cf03887af2cb59e577f169ac0e8b2fd2c3e3409280035f386d407";
  };

  propagatedBuildInputs = [
    werkzeug
  ];

  # all tests access network: does not work in sandbox
  doCheck = false;

  pythonImportsCheck = [
    "pytest_localserver"
  ];

  meta = with lib; {
    description = "Plugin for the pytest testing framework to test server connections locally";
    homepage = "https://github.com/pytest-dev/pytest-localserver";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
