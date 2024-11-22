{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  azure-core,
  typing-extensions,
}:

buildPythonPackage rec {
  version = "1.4.0";
  format = "setuptools";
  pname = "azure-mgmt-core";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-0ZUgg0AJT5jlpmYbeBzeb2oFHnnOMXyqvY/5cDCps64=";
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
