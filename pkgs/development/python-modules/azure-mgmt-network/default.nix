{ lib
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-mgmt-network";
  version = "25.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3OLK+xrg5WPgte/FN9yYp8Ctgk1CYeZL7XX3iBlt1cY=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [
    "azure.mgmt"
  ];

  pythonImportsCheck = [
    "azure.mgmt.network"
  ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson jonringer ];
  };
}
