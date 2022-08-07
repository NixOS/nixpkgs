{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
}:

buildPythonPackage rec {
  pname = "azure-mgmt-monitor";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-trIM1TL86kEg0ycPbTEThh0Bw/MtDyNE5U+X1biTSUE=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = [
    "azure.mgmt"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Monitor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
