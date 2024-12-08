{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  docopt,
  pytz,
  requests,
  setuptools,
  vincenty,
  xmltodict,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "buienradar";
  version = "1.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjj4791";
    repo = "python-buienradar";
    # https://github.com/mjj4791/python-buienradar/issues/14
    rev = "6081a860e190eb59c2ea3ebdcb8a50f6133a0b53";
    hash = "sha256-5bFGPR8StyQTMRcvECdHGC33oAR/9noeCbpwx3DSquQ=";
  };

  propagatedBuildInputs = [
    docopt
    pytz
    requests
    setuptools
    vincenty
    xmltodict
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
    mainProgram = "buienradar";
    homepage = "https://github.com/mjj4791/python-buienradar";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
