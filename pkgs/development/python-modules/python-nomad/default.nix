{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "python_nomad";
    inherit version;
    hash = "sha256-U+bZ7G9mtnKunW0DWRokvi2LVFDdf9vhADgxy5t3+Ec=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

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
