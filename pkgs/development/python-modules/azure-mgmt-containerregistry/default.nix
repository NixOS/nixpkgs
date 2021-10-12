{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "8.1.0";
  pname = "azure-mgmt-containerregistry";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "62efbb03275d920894d79879ad0ed59605163abd32177dcf24e90c1862ebccbd";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common azure-mgmt-core msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.containerregistry" ];

  meta = with lib; {
    description = "Microsoft Azure Container Registry Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
