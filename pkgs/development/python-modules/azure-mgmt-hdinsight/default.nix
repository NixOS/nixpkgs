{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "azure-mgmt-hdinsight";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed55df52d35fc03a9c7ca060af1ec0faf7b5510381d2a5e74b73f59ac0d79028";
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
