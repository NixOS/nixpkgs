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
  version = "12.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HWjIQBWYmU43pSxKLcwx45EExn10jeEkyY9Hpbyn0vw=";
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
