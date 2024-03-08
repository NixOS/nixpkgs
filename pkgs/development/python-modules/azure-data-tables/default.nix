{ lib
, azure-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, typing-extensions
, yarl
}:

buildPythonPackage rec {
  pname = "azure-data-tables";
  version = "12.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7qOTpjgMQusD6AeCXAN4MgA9CcgjKUgx2hXoEVWgtOY=";
  };

  propagatedBuildInputs = [
    azure-core
    isodate
    typing-extensions
    yarl
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.data.tables"
  ];

  meta = with lib; {
    description = "NoSQL data storage service that can be accessed from anywhere";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-data-tables_${version}/sdk/tables/azure-data-tables/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
