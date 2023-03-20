{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-consumption";
  version = "10.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-BqCGQ2wXN/d6uGiU1R9Zc7bg+l7fVlWOTCllieurkTA=";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
  ];

  preBuild = ''
    rm -f azure_bdist_wheel.py
    substituteInPlace setup.cfg \
      --replace "azure-namespace-package = azure-mgmt-nspkg" ""
  '';

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Consumption Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
