{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "azure-mgmt-imagebuilder";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mwlvy4x5nr3hsz7wdpdhpzwarzzwz4225bfpd68hr0pcjgzspky";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.imagebuilder" ];

  meta = with lib; {
    description = "Microsoft Azure Image Builder Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
