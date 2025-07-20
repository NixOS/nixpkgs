{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  azure-core,
  typing-extensions,
}:

buildPythonPackage rec {
  version = "1.5.0";
  format = "setuptools";
  pname = "azure-mgmt-core";

  src = fetchPypi {
    pname = "azure_mgmt_core";
    inherit version;
    extension = "tar.gz";
    hash = "sha256-OArj36Njn0pcJGp9t+0tCDdOiCMP0No+uJn3wR5cRBo=";
  };

  propagatedBuildInputs = [
    azure-core
    typing-extensions
  ];

  pythonNamespaces = "azure.mgmt";

  # not included
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.core"
    "azure.core"
  ];

  meta = with pkgs.lib; {
    description = "Microsoft Azure Management Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = [ ];
  };
}
