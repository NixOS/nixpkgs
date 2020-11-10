{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "azure-mgmt-hdinsight";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd47029f2423e45ec4d311f651dc972043b98e960f186f5c6508c6fdf6eb2fe8";
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
