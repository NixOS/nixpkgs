{ pkgs
, buildPythonPackage
, fetchPypi
, azure-core
, typing-extensions
}:

buildPythonPackage rec {
  version = "1.3.1";
  pname = "azure-mgmt-core";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-yJ6/GMInvJih7sypVGC4p+IwWQ1FbI+pwtWs3GcPeAg=";
  };

  propagatedBuildInputs = [
    azure-core
    typing-extensions
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
