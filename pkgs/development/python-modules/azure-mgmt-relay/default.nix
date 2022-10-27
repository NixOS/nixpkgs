{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-relay";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c93b7550e64b6734bf23ce57ca974a3ea929b734c58d1fe3669728c4fd2d2eb3";
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
  pythonImportsCheck = [ "azure.mgmt.relay" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Relay Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
