{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "9.0.0";
  format = "setuptools";
  pname = "azure-mgmt-hdinsight";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "41ebdc69c0d1f81d25dd30438c14fff4331f66639f55805b918b9649eaffe78a";
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

  pythonImportsCheck = [ "azure.common" "azure.mgmt.hdinsight" ];

  meta = with lib; {
    description = "Microsoft Azure HDInsight Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
