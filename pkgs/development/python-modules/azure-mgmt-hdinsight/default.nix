{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "1.4.0";
  pname = "azure-mgmt-hdinsight";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zmmfj7z1zrayjqwqybcn3bwm47d2ngyxm1g6fh2iw5c2f9czycv";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.hdinsight" ];

  meta = with lib; {
    description = "Microsoft Azure HDInsight Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
