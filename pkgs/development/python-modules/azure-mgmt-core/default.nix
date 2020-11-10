{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-core
, isPy3k
}:

buildPythonPackage rec {
  version = "1.2.1";
  pname = "azure-mgmt-core";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "a3906fa77edfedfcc3229dc3b69489d5ed63b107c7eacbc50092e6cbfbfd83f0";
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
