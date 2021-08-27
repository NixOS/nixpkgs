{ pkgs
, buildPythonPackage
, fetchPypi
, azure-mgmt-core
, azure-mgmt-common
, isPy3k
}:


buildPythonPackage rec {
  version = "19.0.0";
  pname = "azure-mgmt-resource";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "bbb60bb9419633c2339569d4e097908638c7944e782b5aef0f5d9535085a9100";
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
