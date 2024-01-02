{ lib
, pythonOlder
, isodate
, fetchPypi
, buildPythonPackage
, azure-core
}:

buildPythonPackage rec {
  pname = "azure-appconfiguration";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cJIRe68GzY6T7ukhN+coF2m0AD/EFtSh7aZGuyVkAnw=";
  };

  propagatedBuildInputs = [
    azure-core
    isodate
  ];

  # Tests are not shipped
  doCheck = false;

  pythonImportsCheck = [
    "azure.appconfiguration"
  ];

  meta = with lib; {
    description = "Microsoft App Configuration Data Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/appconfiguration/azure-appconfiguration";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-appconfiguration_${version}/sdk/appconfiguration/azure-appconfiguration/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
