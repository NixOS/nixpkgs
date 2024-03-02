{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "4.0.0";
  format = "setuptools";
  pname = "azure-mgmt-apimanagement";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AiTjLJ28g80xnrRFLfPUevJgeaxLpuGmvkd3+FskNiw=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.apimanagement" ];

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
