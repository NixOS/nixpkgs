{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, docopt
, pytz
, requests
, setuptools
, vincenty
, xmltodict
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "buienradar";
  version = "1.0.5";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "mjj4791";
    repo = "python-buienradar";
    # https://github.com/mjj4791/python-buienradar/issues/14
    rev = "caa66ea855dbcc7cf6ee13291d9b2ed7ac01ef98";
    hash = "sha256:0xz03xj5qjayriaah20adh0ycvlvb8jdvgh7w5gm236n64g6krj0";
  };

  propagatedBuildInputs = [
    docopt
    pytz
    requests
    setuptools
    vincenty
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # require network connection
    "test_rain_data"
    "test_json_data"
    "test_xml_data"
  ];

  pythonImportsCheck = [
    "buienradar.buienradar"
    "buienradar.constants"
  ];

  meta = with lib; {
    description = "Library and CLI tools for interacting with buienradar";
    homepage = "https://github.com/mjj4791/python-buienradar";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
