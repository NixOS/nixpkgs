{ pkgs
, buildPythonPackage
, fetchPypi
, azure-mgmt-core
, azure-mgmt-common
, isPy3k
}:


buildPythonPackage rec {
  version = "21.1.0";
  pname = "azure-mgmt-resource";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-UpZa3jHNBZ/qKxUT1l/mFgRuQz3g5YPc9cnJvr8+vWk=";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
  ];

  # has no tests
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.resource" ];

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson jonringer ];
  };
}
