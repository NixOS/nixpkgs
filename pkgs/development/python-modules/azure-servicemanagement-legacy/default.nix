{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, requests
}:

buildPythonPackage rec {
  version = "0.20.7";
  format = "setuptools";
  pname = "azure-servicemanagement-legacy";

  src = fetchPypi {
    inherit version pname;
    extension = "zip";
    sha256 = "1kcibw17qm8c02y28xabm3k1zrawi6g4q8kzc751l5l3vagqnf2x";
  };

  propagatedBuildInputs = [
    azure-common
    requests
  ];

  pythonNamespaces = [ "azure" ];
  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.servicemanagement" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Service Management Legacy Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson ];
  };
}
