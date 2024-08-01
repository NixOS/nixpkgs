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
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "python_nomad";
    inherit version;
    hash = "sha256-TXCm6FxYoavjN3ASioQ7yXQVsDDXedDKBgGGP8ghQdM=";
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
