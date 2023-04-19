{ azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, lib
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-frontdoor";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-nJXQ/BpyOwmybNUqE4cBxq5xxZE56lqgHSTKZTIHIuU=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.frontdoor" ];

  meta = with lib; {
    description = "Microsoft Azure Front Door Service Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
