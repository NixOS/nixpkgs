{ lib, python, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.2.4";
  pname = "azure-multiapi-storage";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zqapc4dx6qd9bcim5fjykk3n1j84p85nwqyb876nb7qmqx9spig";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # fix namespace issues
  postInstall = ''
    rm $out/${python.sitePackages}/azure/__init__.py
    rm $out/${python.sitePackages}/azure/multiapi/__init__.py
  '';

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.multiapi.storage" ];

  meta = with lib; {
    description = "Microsoft Azure Storage Client Library for Python with multi API version support.";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
