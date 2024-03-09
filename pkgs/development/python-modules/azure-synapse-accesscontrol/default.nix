{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-accesscontrol";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "565aa26336d560c028775e8ae50d0691aa7089e96170e78342371b773da3137c";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  # zero tests run
  doCheck = false;

  pythonImportsCheck = [ "azure.synapse.accesscontrol" ];

  meta = with lib; {
    description = "Azure python SDK";
    homepage = "https://github.com/Azure/azure-sdk-for-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
