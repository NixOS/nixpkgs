{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-accesscontrol";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cead7051df3816a3382a74033efa0b8774cb7f8cdf5871c6825dd1638289189";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  pythonImportsCheck = [ "azure.synapse.accesscontrol" ];

  meta = with lib; {
    description = "Azure python SDK";
    homepage = "https://github.com/Azure/azure-sdk-for-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
