{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-common
, azure-mgmt-core
, isodate
}:

buildPythonPackage rec {
  pname = "azure-mgmt-netapp";
  version = "11.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-00cDFHpaEciRQLHM+Kt3uOtw/geOn5+onrY7lav6EeU=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.netapp"
  ];

  meta = with lib; {
    description = "Microsoft Azure NetApp Files Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-netapp_${version}/sdk/netapp/azure-mgmt-netapp/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
