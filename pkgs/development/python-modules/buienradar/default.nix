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
  version = "1.0.4";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "mjj4791";
    repo = "python-buienradar";
    rev = version;
    sha256 = "1s0m5x7wdvzzsm797lh6531k614ybh7z0cikxjxqw377mivpz4wq";
  };

  propagatedBuildInputs = [
    docopt
    pytz
    requests
    setuptools
    vincenty
    xmltodict
  ];

  checkInputs = [
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
