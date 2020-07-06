{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "1.5.1";
  pname = "azure-mgmt-hdinsight";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "18xfq3n2i1bnai417p3q67f4bikxjcqyg6yp4f06kipx8cz4zfbn";
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
