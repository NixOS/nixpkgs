{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-core
, isPy3k
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "azure-mgmt-core";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3ffb7352b39e5495dccc2d2b47254f4d82747aff4735e8bf3267c335b0c9bb40";
  };

  propagatedBuildInputs = [
    azure-core
  ];

  pythonNamespaces = "azure.mgmt";

  # not included
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.core" "azure.core" ];

  meta = with pkgs.lib; {
    description = "Microsoft Azure Management Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
