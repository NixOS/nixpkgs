{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "3.0.0";
  format = "setuptools";
  pname = "azure-mgmt-appconfiguration";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FJhuVgqNjdRIegP4vUISrAtHvvVle5VQFVITPm4HLEw=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  # no tests included
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.common" "azure.mgmt.appconfiguration" ];

  meta = with lib; {
    description = "Microsoft Azure App Configuration Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
