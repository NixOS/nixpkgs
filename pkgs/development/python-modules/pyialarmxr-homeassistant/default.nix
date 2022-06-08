{ lib
, buildPythonPackage
, fetchPypi
, lxml
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "pyialarmxr-homeassistant";
  version = "1.0.18";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aQHJiSmaGyABHP17oFH+6JQ9zNJ6pj2+PcE+gsRuhaQ=";
  };

  propagatedBuildInputs = [
    lxml
    xmltodict
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [
    "pyialarmxr"
  ];

  meta = with lib; {
    description = "Library to interface with Antifurto365 iAlarmXR systems";
    homepage = "https://pypi.org/project/pyialarmxr-homeassistant/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
