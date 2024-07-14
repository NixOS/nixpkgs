{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  requests,
}:

buildPythonPackage rec {
  version = "0.20.7";
  format = "setuptools";
  pname = "azure-servicemanagement-legacy";

  src = fetchPypi {
    inherit version pname;
    extension = "zip";
    hash = "sha256-XTiLn9qDFhrKYX8iTJ6JXOUf5qhLdSS8AAxVfAJfkc0=";
  };

  propagatedBuildInputs = [
    azure-common
    requests
  ];

  pythonNamespaces = [ "azure" ];
  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.servicemanagement" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Service Management Legacy Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      olcai
      maxwilson
    ];
  };
}
