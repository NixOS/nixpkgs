{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-search";
  version = "9.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U7xu6tsJdNIfEguyG7Xmgn321lDhc0dGD9g+LWiINZk=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.search" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Search Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-search_${version}/sdk/search/azure-mgmt-search/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
