{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "pyialarmxr";
  version = "1.0.18";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bigmoby";
    repo = pname;
    rev = version;
    hash = "sha256-Q1NsPLA1W4nxSG/9jlMf6BkC3ZrUrhl8oDX7U4aAjxM=";
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
    homepage = "https://github.com/bigmoby/pyialarmxr";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
