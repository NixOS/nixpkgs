{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-core
, isPy3k
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-mgmt-core";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0pm565v05480f672l0n8z2sg6zk6iqyi91n0dhscibhdl54sy3si";
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
