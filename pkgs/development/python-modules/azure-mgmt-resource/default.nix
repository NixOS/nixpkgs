{ pkgs
, buildPythonPackage
, fetchPypi
, azure-mgmt-core
, azure-mgmt-common
, isPy3k
}:


buildPythonPackage rec {
  version = "21.2.1";
  pname = "azure-mgmt-resource";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-vSBg1WOT/+Ykao8spn51Tt0D7Ae5dWMLMK4DqIYFl6c=";
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
