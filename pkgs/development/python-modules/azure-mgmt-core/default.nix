{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-core
, isPy3k
}:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "azure-mgmt-core";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "8fe3b59446438f27e34f7b24ea692a982034d9e734617ca1320eedeee1939998";
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
