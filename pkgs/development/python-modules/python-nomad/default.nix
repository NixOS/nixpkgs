{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5IyHNw1ArE8fU9DoSQMGkDI9d/OiR1YI/7nTPeFIK+A=";
  };

  propagatedBuildInputs = [ requests ];

  # Tests require nomad agent
  doCheck = false;

  pythonImportsCheck = [ "nomad" ];

  meta = with lib; {
    description = "Python client library for Hashicorp Nomad";
    homepage = "https://github.com/jrxFive/python-nomad";
    changelog = "https://github.com/jrxFive/python-nomad/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ xbreak ];
  };
}
