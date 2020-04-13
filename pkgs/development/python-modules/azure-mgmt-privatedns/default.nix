{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "azure-mgmt-privatedns";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "08wdvfkk8jh90m3l4nz7knd5vikgfvsx70lk7mkhcvl0xj6gv76j";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.privatedns" ];

  meta = with lib; {
    description = "Microsoft Azure DNS Private Zones Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
