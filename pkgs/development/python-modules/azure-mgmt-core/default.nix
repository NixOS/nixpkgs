{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-core
, isPy3k
}:

buildPythonPackage rec {
  version = "1.2.2";
  pname = "azure-mgmt-core";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4246810996107f72482a9351cf918d380c257e90942144ec9c0c2abda1d0a312";
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
